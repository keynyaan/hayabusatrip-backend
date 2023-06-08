module Api
  module V1
    class SpotsController < ApplicationController
      before_action :set_trip
      # idTokenの検証をスキップする
      skip_before_action :authenticate, only: [:index, :show]

      # 特定の旅行プラン中の旅行スポットの一覧取得
      def index
        @spots = @trip.spots
        render json: @spots
      end

      # 特定の旅行スポットの取得
      def show
        @spot = @trip.spots.find_by(id: params[:id])
        if @spot
          render json: @spot
        else
          render json: { error: { messages: ["指定された旅行スポットが見つかりませんでした。"] } }, status: :not_found
        end
      end

      # 旅行スポットの登録
      def create
        @spot = @trip.spots.build(spot_params)
        if @spot.save
          render json: @spot
        else
          render json: { error: { messages: ["旅行スポットを登録できませんでした。"] } }, status: :unprocessable_entity
        end
      end

      # 旅行スポットの更新
      def update
        @spot = @trip.spots.find_by(id: params[:id])
        if @spot
          if @spot.update(spot_params)
            render json: @spot
          else
            render json: { error: { messages: ["旅行スポットの更新に失敗しました。"] } }, status: :unprocessable_entity
          end
        else
          render json: { error: { messages: ["指定された旅行スポットが見つかりませんでした。"] } }, status: :not_found
        end
      end

      # 旅行スポットの削除
      def destroy
        @spot = @trip.spots.find_by(id: params[:id])
        if @spot
          @spot.destroy
          head :no_content
        else
          render json: { error: { messages: ["#{params[:id]}の旅行スポットが存在しません。"] } }, status: :not_found
        end
      end

      private

      def set_trip
        @user = User.find_by!(uid: params[:user_uid])
        @trip = @user.trips.find_by!(trip_token: params[:trip_trip_token])
      end

      # 旅行スポット用のパラメーター
      def spot_params
        params.require(:spot).permit(:spot_icon, :title, :date, :start_time, :end_time, :cost, :memo)
      end
    end
  end
end
