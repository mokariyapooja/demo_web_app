class SessionController < ApplicationController
  skip_before_action :authenticate_user!, only: :create
  def create
    user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    sign_in user
    redirect_to root_url
  end
end  
 