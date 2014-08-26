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

  def edit
    @album = Album.find(params[:id])
  end

  def update 
    @album = Album.find(params[:id])
    @album.update_attributes(album_params)
    if @album.update_attributes(album_params)
      redirect_to user_album_path(current_user,@album)
      flash[:notice] = "Successfully updated Album"
    else
      render 'edit'
    end
  end

  #to fetch albums from facebook
  def facebook_album
    @user = User.find(params[:user_id])
    @graph = @user.get_graph_object
    @albums = @user.fetch_facebook_albums
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    redirect_to user_path(current_user)
  end  

  #delete perticular photo from album
  def delete_photo
    @album = current_user.albums.find(params[:album_id])
    @photo = @album.photos.find(params[:photo_id])
    @photo.destroy
    redirect_to user_album_path(current_user,@album)
  end  

  private
  def album_params   
    params.require(:album).permit(:name,:privacy,photos_attributes: [:id,:_destroy,:data])
  end
end