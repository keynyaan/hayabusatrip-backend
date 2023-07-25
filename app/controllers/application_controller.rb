class ApplicationController < ActionController::API
  # Firebase Authenticator用のモジュールを読み込み
  include FirebaseAuthenticator

  # エラー用クラス設定
  class NoIdtokenError < StandardError; end
  rescue_from NoIdtokenError, with: :no_idtoken

  # idTokenの検証を実行
  before_action :authenticate

  private

  # idTokenの検証
  def authenticate
    # idTokenが付与されていない場合はエラー処理
    raise NoIdtokenError unless request.headers["Authorization"]

    @payload = decode(request.headers["Authorization"]&.split&.last)
  end

  # idTokenが付与されていない場合
  def no_idtoken
    render json: { error: { messages: ["idTokenが付与されていないため、認証できませんでした。"] } }, status: :unauthorized
  end
end
