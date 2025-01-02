require 'net/http'
require 'uri'
require 'json'

class Api::V1::LineWebhookController < ApplicationController

  # Webhookエントリポイント
  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    # 署名検証（LINEサーバーからの正当なリクエストか確認）
    unless validate_signature(body, signature)
      Rails.logger.error("Invalid signature")
      head :bad_request
      return
    end

    # LINEから送信されたイベント情報を取得
    events = JSON.parse(body)['events']
    events.each do |event|
      case event['type']
      when 'message' # ユーザーがメッセージを送信した場合
        handle_message_event(event)
      when 'follow' # ユーザーがBotを友だち追加した場合
        handle_follow_event(event)
      end
    end

    head :ok
  end

  private

  # 署名検証
  def validate_signature(body, signature)
    channel_secret = ENV['LINE_CHANNEL_SECRET']
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, channel_secret, body)
    Base64.strict_encode64(hash) == signature
  end

  # メッセージイベントの処理
  def handle_message_event(event)
    user_id = event['source']['userId'] # ユーザーのLINE ID
    user_message = event['message']['text'] # ユーザーが送信したメッセージ

    # 応答メッセージを生成
    response_message = "あなたのメッセージ: #{user_message}"

    # プッシュメッセージを送信
    send_push_message(user_id, response_message)
  end

  # 友だち追加イベントの処理
  def handle_follow_event(event)
    user_id = event['source']['userId']

    # ユーザーをデータベースに保存（データベース設計が必要）
    User.find_or_create_by(line_user_id: user_id)

    # プッシュメッセージを送信
    send_push_message(user_id, "友だち追加ありがとうございます！")
  end

  # プッシュメッセージを送信するメソッド
  def send_push_message(user_id, text)
    uri = URI.parse("https://api.line.me/v2/bot/message/push")
    header = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{ENV['LINE_ACCESS_TOKEN']}"
    }
    body = {
      to: user_id,
      messages: [
        {
          type: 'text',
          text: text
        }
      ]
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body.to_json
    response = http.request(request)

    Rails.logger.info("LINE API Response: #{response.body}")
  end
end
