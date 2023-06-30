module Notifiable
  extend ActiveSupport::Concern

  included do
    after_create_commit :post_notification
  end

  private def post_notification
    ActionCable.server.broadcast('notification_posted',
                                 { id: id,
                                   type: self.class.name,
                                   topics: try(:topic_list) || [],
                                   poster_name: user.name })
  end
end
