class PhotosController < ApplicationController
  before_action :set_community
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  
  # GET /photos
  # GET /photos.json
  def index
    @photos = @album.photos.all
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end
  
  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    @photo.assign_attributes(photo_params)
    image = @photo.image.download
    converted_image = MiniMagick::Image.open(image.path)
    converted_image.rotate @photo.orient
     @photo.image = File.open(converted_image.path)
    if @photo.save
      flash[:success] = 'Photo was successfully updated.'
      redirect_to @photo.community
    else
      flash[:danger] = 'Something wrong.'
      render 'show'
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    if @photo.destroy
      flash[:success]= 'Photo was successfully destroyed.'
      redirect_to @community
    end
  end
  
  def create
    @photo = @community.photos.new(photo_params)
    respond_to do |format|
      if @photo.save
        format.html { redirect_to @community, flash: { success: 'Image was successfully uploaded.' } }
        format.json { render :show, status: :created, location: [@community, @photo] }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    def set_photo
      @photo = Photo.find_by_id(params[:id])
    end
    
    def set_community
      @community = Community.find_by_id(params[:community_id])
    end
    
    def photo_params
      params.require(:photo).permit(:image, :orient, :viewable)
    end
end