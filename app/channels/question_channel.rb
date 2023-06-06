class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'question_posted'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create_notification(data)
    notification = @connection.current_user
                              .notifications
                              .build(question_id: data['id'])
    Rails.logger.info('notification could not be made') unless notification.save
  end
end
