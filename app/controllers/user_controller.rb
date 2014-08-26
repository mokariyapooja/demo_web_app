class UserController < ApplicationController
  
  def index
    @title = "User all" 
    @users = User.all 
  end 

  def show
    @user = User.find(params[:id])   
  end

  #to search user from list
  def search
    @users = User.search(params[:search])
    render 'index'
  end

  #to follow user
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

  #to unfollow user
  def unfollow
    @user = User.find(params[:user_id])
    if current_user
      current_user.stop_following(@user)
      redirect_to @user
      flash[:notice] = "You are no longer following."
    end
  end

  #list of following users
  def following
    @title = "Following"
    @user = User.find(params[:user_id])
    @users = @user.all_following
    render 'index'
  end

  #list of follower users
  def followers
    @title = "Followers"
    @user = User.find(params[:user_id])
    @users = @user.followers
    render 'index'
  end
end