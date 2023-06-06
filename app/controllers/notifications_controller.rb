class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :read_all
  before_action :set_notifications

  def read_all
    if @notifications.unread.map(&:read!).all?
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'failed' }, status: 422
    end
  end

  private def set_notifications
    @notifications = current_user.notifications
                                 .includes(:user,
                                           question: %i[topics user])
                                 .page(params[:page])
  end
end
