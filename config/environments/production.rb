require "active_support/core_ext/integer/time"

Rails.application.configure do
  # SMTP設定（Mailgun）
  config.action_mailer.default_url_options = {
  host: 'moe-todo-back-21c0a9ec06a3.herokuapp.com',
  protocol: 'https'
}

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.mailgun.org',
    port: 587,
    domain: ENV['MAILGUN_DOMAIN'],
    user_name: ENV['MAILGUN_SMTP_LOGIN'],
    password: ENV['MAILGUN_SMTP_PASSWORD'],
    authentication: :plain,
    enable_starttls_auto: true
  }

  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  config.active_storage.service = :amazon

  # SSLを強制
  config.force_ssl = true

  # ログ設定
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
end
