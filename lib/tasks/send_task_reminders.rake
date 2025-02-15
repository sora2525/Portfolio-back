# back/lib/tasks/send_task_reminders.rake
namespace :send_task_reminders do
    desc "ユーザーにタスクリマインダーを送信する"
    task perform: :environment do
      NotificationService.send_task_reminders
    end
  end
  
  