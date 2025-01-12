# back/app/services/line_notification_service.rb
require 'line/bot'

class LineNotificationService
  def self.send_message(line_sub, message)
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_ACCESS_TOKEN']
    end

    message = {
      type: 'text',
      text: message
    }

    response = client.push_message(line_sub, message)

    Rails.logger.info("LINE API Response: #{response.body}")
  rescue StandardError => e
    Rails.logger.error("LINE Notification Error: #{e.message}")
  end
end
