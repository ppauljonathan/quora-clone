class Notification < ApplicationRecord
  STATUSES = {
    unread: 0,
    read: 1
  }

  belongs_to :notifiable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: %i[notifiable_type notifiable_id] }

  default_scope { order created_at: :desc }

  enum :status, STATUSES, default: :unread
end
