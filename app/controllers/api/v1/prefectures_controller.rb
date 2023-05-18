module Api
  module V1
    class PrefecturesController < ApplicationController
      # idTokenの検証をスキップする
      skip_before_action :authenticate, only: [:index, :show]

      # 全ての都道府県情報の取得
      def index
        @prefectures = Prefecture.all
        render json: @prefectures
      end

      # 特定の都道府県情報の取得
      def show
        @prefecture = Prefecture.find_by(id: params[:id])
        if @prefecture
          render json: @prefecture
        else
          render status: :not_found
        end
      end
    end
  end
end
