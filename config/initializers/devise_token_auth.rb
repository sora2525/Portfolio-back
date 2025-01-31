# frozen_string_literal: true

DeviseTokenAuth.setup do |config|
  # パスワードリセット用のデフォルトURL
  config.default_password_reset_url = 'https://www.task-yell.jp/password-reset'

  # リクエストごとにAuthorizationヘッダーを変更しない設定
  config.change_headers_on_each_request = false

  config.require_client_password_reset_token = true

  # トークンの有効期間（デフォルト2週間）
  config.token_lifespan = 2.weeks

  # テスト環境でのトークン生成のコスト
  config.token_cost = Rails.env.test? ? 4 : 10

  # ヘッダーの名前を設定
  config.headers_names = {
    :'authorization' => 'Authorization',
    :'access-token'  => 'access-token',
    :'client'        => 'client',
    :'expiry'        => 'expiry',
    :'uid'           => 'uid',
    :'token-type'    => 'token-type'
  }
end
