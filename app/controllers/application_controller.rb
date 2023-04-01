class ApplicationController < ActionController::API
  def test
    test_json_obj = [
      { id: 1, title: "First Text", text: "最初のテキスト" },
      { id: 2, title: "Second Text", text: "2番目のテキスト" },
    ]
    render json: test_json_obj
  end
end
