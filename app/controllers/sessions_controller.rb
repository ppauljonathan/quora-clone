class SessionsController < ApplicationController
  def create
    user = User.find_by(email: user_params[:email])

    if user.try(:authenticate, user_params[:password])
      if user.verified?
        session[:user_id] = user.id
        redirect_to '/'
      else
        render :new, error: 'User is not verified yet', status: 422
      end
    else
      render :new, error: 'Invalid email/password combination', status: 422
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
