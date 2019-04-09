class Task < ApplicationRecord
  validates :title , presence: true , length: {maximum:20}
  validates :content , presence: true , length: {maximum:200}
  enum status: { 未着手:0, 着手:1, 完了:2}
  validates :status, inclusion:{ in: Task.statuses.keys}
  enum priority: { 高:0, 中:1, 低:2}
  validates :priority, inclusion:{ in: Task.priorities.keys}
  belongs_to :user
  scope :search_task, ->(title , status) do
    return if (title.nil?  && status.nil?)

    if title.present? && status.present?
      where("title like ? AND status = ?", user_id ,"%#{title}%" ,  status)
    elsif title.present?
      where("title like ?", user_id ,"%#{title}%")
    elsif status.present?
      where("status = ?", user_id ,status)
    end

  end

  scope :find_self_task, ->(user_id) do
    where("user_id = ?", user_id)
  end


  validate :deadline_at_cannot_be_in_the_past, on: :create
 
  def deadline_at_cannot_be_in_the_past
    if deadline_at.present? && deadline_at < Date.today
      errors.add(:deadline_at, Task.human_attribute_name('err_msg_deadline_at'))
    end
  end
end
