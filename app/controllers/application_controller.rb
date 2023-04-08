class ApplicationController < ActionController::API
  def test
    test_json_obj = [
      { id: 1, title: "First Text", text: "最初のテキスト" },
      { id: 2, title: "Second Text", text: "2番目のテキスト" },
    ]
    render json: test_json_obj
  end

  # Firebase Authenticator用のモジュールを読み込み
  include FirebaseAuthenticator

  # エラー用クラス設定
  class NoIdtokenError < StandardError; end
  rescue_from NoIdtokenError, with: :no_idtoken

  # idTokenの検証を実行
  before_action :authenticate
  # テスト用APIはidTokenの検証をスキップする
  skip_before_action :authenticate, only: [:test]

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
