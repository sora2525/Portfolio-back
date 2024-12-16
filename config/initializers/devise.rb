# frozen_string_literal: true

Devise.setup do |config|
  # メール送信元のアドレス
  config.mailer_sender = ENV['MAILER_SENDER_EMAIL']

  # ORM設定（ActiveRecordを使用）
  require 'devise/orm/active_record'

  # 認証キーの設定
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # セッションストレージをスキップする設定
  config.skip_session_storage = [:http_auth]

  # パスワードのハッシュ化コスト
  config.stretches = Rails.env.test? ? 1 : 12

  # パスワードリセットの有効期間
  config.reset_password_within = 6.hours

  # パスワード長の設定
  config.password_length = 6..128

  # サインアウトのHTTPメソッド
  config.sign_out_via = :delete

  # パスワード変更後に自動でサインインする設定
  config.sign_in_after_reset_password = true

  # Hotwire/Turboの設定
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
