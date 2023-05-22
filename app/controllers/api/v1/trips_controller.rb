module Api
  module V1
    class TripsController < ApplicationController
      # 特定の旅行プランの取得
      def show
        @trip = Trip.find_by(trip_token: params[:trip_token])
        if @trip
          render json: @trip
        else
          render json: { error: { messages: ["指定された旅行プランが見つかりませんでした。"] } }, status: :not_found
        end
      end

      # 旅行プランの登録
      def create
        @trip = Trip.new(trip_params.except(:trip_token))

        # 指定された都道府県のデフォルト画像を設定
        prefecture = Prefecture.find_by(id: params[:trip][:prefecture_id])
        if prefecture
          @trip.image_path = prefecture.image_path
        else
          render json: { error: { messages: ["指定された都道府県が見つかりませんでした。"] } }, status: :not_found
          return
        end

        # 16桁のランダムで一意な英数字のtrip_tokenを生成
        loop do
          @trip.trip_token = SecureRandom.alphanumeric(16)
          break unless Trip.exists?(trip_token: @trip.trip_token)
        end

        if @trip.save
          render json: @trip
        else
          render json: { error: { messages: ["旅行プランを登録できませんでした。"] } }, status: :unprocessable_entity
        end
      end

      # 旅行プランの更新
      def update
        @trip = Trip.find_by(trip_token: params[:trip_token])
        if @trip
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
        trip = Trip.find_by(trip_token: params[:trip_token])
        if trip
          trip.destroy
          render json: { messages: ["#{params[:trip_token]}の旅行プランを削除しました。"] }
        else
          render json: { error: { messages: ["#{params[:trip_token]}の旅行プランが存在しません。"] } }, status: :not_found
        end
      end

      private

      # 旅行プラン用のパラメーター
      def trip_params
        params.require(:trip).permit(:user_id, :prefecture_id, :title, :start_date, :end_date, :memo, :image_path,
                                     :is_public)
      end
    end
  end
end
