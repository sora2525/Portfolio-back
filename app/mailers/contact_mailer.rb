class ContactMailer < ApplicationMailer
    default from: "postmaster@mero.task-yell.jp"
  
    def send_contact_email(contact_params)
      @name = contact_params[:name]
      @email = contact_params[:email]
      @message = contact_params[:message]
  
      mail(
        to: ENV["CONTACT_EMAIL"], # ここで環境変数から取得！
        subject: "新しいお問い合わせがありました"
      )
    end
  end
  