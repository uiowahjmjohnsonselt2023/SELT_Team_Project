class ImagesController < ApplicationController
    def new
      @images = Image.order('created_at DESC')
      @image = Image.new
    end
  
    def create
      @image = Image.new(image_params)
      @image.save
      redirect_to new_image_path
    end
  
    private
    def image_params
      params.require(:image).permit(:user_id, :image)
    end
end