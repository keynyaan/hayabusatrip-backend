module Api
  module V1
    class TripsController < ApplicationController
      # idTokenの検証をスキップする
      skip_before_action :authenticate, only: [:show]

      # ユーザーの旅行プランの一覧取得
      def index
        @trips = User.find_by(uid: params[:user_uid])&.trips
        if @trips
          render json: @trips
        else
          render json: { error: { messages: ["指定されたユーザーの旅行プランが見つかりませんでした。"] } }, status: :not_found
        end
      end

      # 特定の旅行プランの取得
      def show
        if params[:user_uid]
          @trip = User.find_by(uid: params[:user_uid])&.trips&.find_by(trip_token: params[:trip_token])
        else
          @trip = Trip.where(is_public: true).find_by(trip_token: params[:trip_token])
        end

        if @trip
          render json: @trip
        else
          render json: { error: { messages: ["指定された旅行プランが見つかりませんでした。"] } }, status: :not_found
        end
      end

      # 旅行プランの登録
      def create
        if params[:copy_trip_token]
          # コピー元のtripとspotsを取得
          original_trip = Trip.find_by(trip_token: params[:copy_trip_token])
          return render json: { error: { messages: ["コピー元の旅行プランが見つかりませんでした。"] } },
                        status: :not_found unless original_trip

          original_spots = original_trip.spots

          # コピー元のtripから新しいtripを作成
          @trip = User.find_by(uid: params[:user_uid])&.trips&.build(original_trip.attributes.except("id",
                                                                                                     "trip_token",
                                                                                                     "created_at",
                                                                                                     "updated_at"))

          # 新しいtripのタイトルと公開設定を変更
          @trip.title = "#{original_trip.title}のコピー"
          @trip.is_public = false

          # 16桁のランダムで一意な英数字のtrip_tokenを生成
          loop do
            @trip.trip_token = SecureRandom.alphanumeric(16)
            break unless Trip.exists?(trip_token: @trip.trip_token)
          end

          if @trip.save
            # コピー元の各spotから新しいspotを作成し、新しいtripに紐付ける
            original_spots.each do |original_spot|
              new_spot = @trip.spots.build(original_spot.attributes.except("id", "trip_id", "created_at", "updated_at"))
              new_spot.save
            end

            render json: @trip
          else
            render json: { error: { messages: ["旅行プランを登録できませんでした。"] } },
                   status: :unprocessable_entity
          end
        else
          @trip = User.find_by(uid: params[:user_uid])&.trips&.build(trip_params.except(:trip_token))

          # パラメーターにimage_pathが設定されていないときのみ、指定された都道府県のデフォルト画像を設定
          unless params[:trip][:image_path]
            prefecture = Prefecture.find_by(id: params[:trip][:prefecture_id])
            if prefecture
              @trip.image_path = prefecture.image_path
            else
              render json: { error: { messages: ["指定された都道府県が見つかりませんでした。"] } }, status: :not_found
              return
            end
          end

          # 16桁のランダムで一意な英数字のtrip_tokenを生成
          loop do
            @trip.trip_token = SecureRandom.alphanumeric(16)
            break unless Trip.exists?(trip_token: @trip.trip_token)
          end

          if @trip.save
            set_preset_spots
            render json: @trip
          else
            render json: { error: { messages: ["旅行プランを登録できませんでした。"] } }, status: :unprocessable_entity
          end
        end
      end

      # 旅行プランの更新
      def update
        @trip = Trip.find_by(trip_token: params[:trip_token])
        if @trip && @trip.user.uid == params[:user_uid]
          # パラメーターにprefecture_idが設定されたときのみ、旅行プランの画像を指定された都道府県の画像に設定
          if params[:trip][:prefecture_id]
            prefecture = Prefecture.find_by(id: params[:trip][:prefecture_id])
            if prefecture
              params[:trip][:image_path] = prefecture.image_path
            else
              render json: { error: { messages: ["指定された都道府県が見つかりませんでした。"] } }, status: :not_found
              return
            end
          end

          if @trip.update(trip_params)
            render json: @trip
          else
            render json: { error: { messages: ["旅行プランの更新に失敗しました。"] } }, status: :unprocessable_entity
          end
        else
          render json: { error: { messages: ["指定された旅行プランが見つかりませんでした。"] } }, status: :not_found
        end
      end

      # 旅行プランの削除
      def destroy
        @trip = Trip.find_by(trip_token: params[:trip_token])
        if @trip && @trip.user.uid == params[:user_uid]
          @trip.destroy
          head :no_content
        else
          render json: { error: { messages: ["指定された旅行プランが存在しませんでした。"] } }, status: :not_found
        end
      end

      private

      # 旅行プラン用のパラメーター
      def trip_params
        params.expect(trip: [:prefecture_id, :title, :start_date, :end_date, :memo, :image_path, :is_public])
      end

      # プリセット用のスポットを登録
      def set_preset_spots
        start_date = @trip.start_date
        end_date = @trip.end_date
        diff_days = (end_date - start_date).to_i

        case diff_days
        when 0
          # 日帰り旅行の場合
          create_spots(start_date, ["移動", "昼食", "観光", "帰宅"])
        when 1
          # 1泊の旅行の場合
          create_spots(start_date, ["移動", "昼食", "観光", "チェックイン"])
          create_spots(end_date, ["チェックアウト", "昼食", "観光", "帰宅"])
        else
          # 2泊以上の旅行の場合
          create_spots(start_date, ["移動", "昼食", "観光", "チェックイン"])
          ((start_date + 1)..(end_date - 1)).each do |date|
            create_spots(date, ["チェックアウト", "昼食", "観光", "チェックイン"])
          end
          create_spots(end_date, ["チェックアウト", "昼食", "観光", "帰宅"])
        end
      end

      # スポットを作成
      def create_spots(date, activities)
        spot_templates = {
          "移動" => { category: "car", start_time: "09:00", end_time: "12:00", cost: 15000,
                    memo: "レンタカーを事前に予約する" },
          "昼食" => { category: "meal", start_time: "12:00", end_time: "13:00", cost: 1000, memo: "" },
          "観光" => { category: "sightseeing", start_time: "13:00", end_time: "17:00", cost: 2000, memo: "" },
          "チェックイン" => { category: "stay", start_time: "17:00", end_time: "18:00", cost: 10000, memo: "" },
          "チェックアウト" => { category: "stay", start_time: "09:00", end_time: "10:00", cost: 0, memo: "" },
          "帰宅" => { category: "car", start_time: "17:00", end_time: "20:00", cost: 0, memo: "" }
        }

        activities.each do |activity|
          template = spot_templates[activity]
          @trip.spots.create(
            category: template[:category],
            name: activity,
            date: date,
            start_time: Time.zone.parse(template[:start_time]),
            end_time: Time.zone.parse(template[:end_time]),
            cost: template[:cost],
            memo: template[:memo]
          )
        end
      end
    end
  end
end
