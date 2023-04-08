module Api
  module V1
    class UsersController < ApplicationController
      # 新規ユーザー登録
      def create
        @user = User.new(uid: payload_uid)
        if @user.save
          render json: @user
        else
          render json: { error: { messages: ["新規ユーザーを登録できませんでした。"] } }, status: unprocessable_entity
        end
      end

      # ユーザーの削除
      def destroy
        user = User.find_by(uid: payload_uid)
        if user
          user.destroy
          render json: { messages: ["#{payload_uid}のユーザーを削除しました。"] }
        else
          render json: { error: { messages: ["#{payload_uid}のユーザーが存在しません。"] } }, status: :not_found
        end
      end

      private

      # payloadのuidを返すメソッド
      def payload_uid
        @payload["user_id"]
      end
    end
  end
end
