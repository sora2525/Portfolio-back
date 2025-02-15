# back/app/services/notification_service.rb
class NotificationService
    def self.send_task_reminders
      Rails.logger.info("NotificationService: send_task_reminders started")
      
      Task.where("reminder_time <= ? AND completion_date IS NULL AND notified = ?", Time.current, false).find_each do |task|
        Rails.logger.info("Processing Task ID: #{task.id}")
        
        user = task.user
        next unless user.line_sub.present?
  
        message = "タスクの期限が近づいています！\nタスク名: #{task.title}\n期限: #{task.due_date}"
  
        if LineNotificationService.send_message(user.line_sub, message)
          task.update(notified: true)
        else
          Rails.logger.error("Failed to send notification for Task ID: #{task.id}")
        end
      end
  
      Rails.logger.info("NotificationService: send_task_reminders completed")
    end
  end
  