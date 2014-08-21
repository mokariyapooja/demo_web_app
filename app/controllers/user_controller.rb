class UserController < ApplicationController
  
  def index
    @title = "User all" 
    @users = User.all
  end 

  def show
    @user = User.find(params[:id])   
  end

  def follow
    @user = User.find(params[:user_id])
    if current_user
      if current_user == @user
        redirect_to @user    
      else
        current_user.follow(@user)
        redirect_to @user
        flash[:notice] = "You are now following ."
      end 
    end
  end

  def unfollow
    @user = User.find(params[:user_id])
    if current_user
      current_user.stop_following(@user)
      redirect_to @user
      flash[:notice] = "You are no longer following."
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:user_id])
    @users = @user.all_following
    render 'index'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:user_id])
    @users = @user.followers
    render 'index'
  end
end
 