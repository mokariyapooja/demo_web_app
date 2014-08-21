class AlbumsController < ApplicationController
  
  def index
    @title = "All Album"
    @user= User.find(params[:user_id])
    if current_user == @user
      @albums = current_user.albums
    elsif current_user.following?(@user) && @user.following?(current_user)
       @albums = @user.albums.where("privacy = ? or privacy = ?", Album::PRIVACY.index("public"),Album::PRIVACY.index("visible to friends") )
     else 
      @albums = @user.albums.where(:privacy => Album::PRIVACY.index("public"))
    end
  end

  def new
    @album = current_user.albums.build
  end

  def show
    @album = Album.find(params[:id])
  end
     
  def create
    @album = current_user.albums.build(album_params)  
      if @album.save
         redirect_to user_album_path(current_user,@album)
      else
        render 'new'
      end
  end

  def facebook_album
    @user = User.find(params[:user_id])
    @graph = @user.get_graph_object
    @albums = @user.fetch_facebook_albums
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    redirect_to root_path
  end      

  private
  def album_params   
    params.require(:album).permit(:name,:privacy,photos_attributes: [:id, :name, :_destroy,:data])
  end
end