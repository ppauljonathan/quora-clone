class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'notification_posted'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create_notification(data)
    notification = @connection.current_user
                              .notifications
                              .build(notifiable_id: data['id'], notifiable_type: data['type'])
    Rails.logger.info('notification could not be made') unless notification.save
  end
end
