module Api
  module V1
    class UsersController < ApplicationController
      # 全てのユーザー情報の取得
      def index
        @users = User.all
        render json: @users
      end

      # 特定のユーザー情報の取得
      def show
        @user = User.find_by(uid: params[:uid])
        # ユーザーが見つからない場合はnullを返す
        render json: @user
      end

      # ユーザーの登録
      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user
        else
          render json: { error: { messages: ["新規ユーザーを登録できませんでした。"] } }, status: :unprocessable_entity
        end
      end

      # ユーザー情報の更新
      def update
        @user = User.find_by(uid: params[:uid])
        if @user
          if @user.update(user_params)
            render json: @user
          else
            render json: { error: { messages: ["ユーザー情報の更新に失敗しました。"] } }, status: :unprocessable_entity
          end
        else
          render json: { error: { messages: ["指定されたユーザーが見つかりませんでした。"] } }, status: :not_found
        end
      end

      # ユーザーの削除
      def destroy
        user = User.find_by(uid: params[:uid])
        if user
          user.destroy
          render json: { messages: ["#{params[:uid]}のユーザーを削除しました。"] }
        else
          render json: { error: { messages: ["#{params[:uid]}のユーザーが存在しません。"] } }, status: :not_found
        end
      end

      private

      # ユーザー用のパラメーター
      def user_params
        params.require(:user).permit(:uid, :name, :icon_path, :request_count, :last_reset_date, :last_login_time)
      end

      # payloadのuidを返すメソッド
      def payload_uid
        @payload["user_id"]
      end
    end
  end
end
