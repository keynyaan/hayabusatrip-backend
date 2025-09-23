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
          render json: { error: { messages: ["ユーザーを登録できませんでした。"] } }, status: :unprocessable_entity
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
          head :no_content
        else
          render json: { error: { messages: ["指定されたユーザーが存在しませんでした。"] } }, status: :not_found
        end
      end

      private

      # ユーザー用のパラメーター
      def user_params
        params.expect(user: [:uid, :name, :icon_path, :last_login_time])
      end

      # payloadのuidを返すメソッド
      def payload_uid
        @payload["user_id"]
      end
    end
  end
end
