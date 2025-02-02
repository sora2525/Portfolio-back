module Api
    module V1
      class ContactsController < ApplicationController
        def create
          begin
            Rails.logger.info "受け取ったパラメータ: #{params.inspect}"
            contact_params = params.permit(:name, :email, :message)
  
            if contact_params[:name].blank? || contact_params[:email].blank? || contact_params[:message].blank?
              raise "必須パラメータが不足しています"
            end
  
            ContactMailer.send_contact_email(contact_params).deliver_now
            Rails.logger.info "メール送信完了"
  
            render json: { message: "お問い合わせを送信しました。" }, status: :ok
          rescue StandardError => e
            Rails.logger.error "エラー発生: #{e.message}"
            render json: { error: "送信に失敗しました: #{e.message}" }, status: :unprocessable_entity
          end
        end
      end
    end
  end
  