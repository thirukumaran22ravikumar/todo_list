class TaskReminderJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find(task_id)
    task_asse = User.find_by(Id: task.assignee_id)
    p task_asse.to_s
    return if task.completion_status || task.due_date < Time.current

    UserMailer.task_reminder(task,task_asse).deliver_now
  end
end
