require 'line/bot'

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
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message # ユーザーがメッセージを送信した場合
        handle_message_event(event)
      when Line::Bot::Event::Follow # ユーザーがBotを友だち追加した場合
        handle_follow_event(event)
      end
    end

    head :ok
  end

  private

  # LINEクライアントのインスタンス
  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_ACCESS_TOKEN']
    end
  end

  # 署名検証
  def validate_signature(body, signature)
    client.validate_signature(body, signature)
  end

  # メッセージイベントの処理
  def handle_message_event(event)
    user_id = event['source']['userId'] # ユーザーのLINE ID
    user_message = event.message['text'] # ユーザーが送信したメッセージ

    # 応答メッセージを生成
    response_message = {
      type: 'text',
      text: "タスクエールで待ってるね！\nhttps://www.task-yell.jp"
    }

    # 応答メッセージを送信
    client.reply_message(event['replyToken'], response_message)
  end

  # 友だち追加イベントの処理
  def handle_follow_event(event)
    user_id = event['source']['userId']

    # ユーザーをデータベースに保存
    User.find_or_create_by(line_user_id: user_id)

    # 挨拶メッセージを送信
    greeting_message = {
      type: 'text',
      text: '友だち追加ありがとうございます！\nhttps://www.task-yell.jp'
    }
    client.push_message(user_id, greeting_message)
  end
end
