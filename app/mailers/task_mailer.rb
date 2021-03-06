class TaskMailer < ApplicationMailer
  def deadline_at(user, tasks)
    @user = user
    @tasks = tasks
    mail to: user.mail
    mail subject: "終了期限間近のタスクがあります"
  end
end
