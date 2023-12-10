class Image < ActiveRecord::Base
    dragonfly_accessor :image do 
      storage_options do |image|
        { path: "images/#{SecureRandom.uuid}.#{image.format}" }   # Path where the images are stored
      end
    end
    
    belongs_to :product
    belongs_to :user

    validates :image, presence: true
    validate :product_or_user_present

    validates_size_of :image, maximum: 2.megabytes,
                      message: "should be no more than 2 MB", if: :image_changed?
  
    validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false,
                       message: "should be either .jpeg, .jpg, .png, .bmp", if: :image_changed?

    before_save :set_image_name

    private 
    def set_image_name
        self.image_name = self.image.path.split("/").last   # sets the name of the image to the renamed image.
    end

    def product_or_user_present
      unless product_id.present? || user_id.present?
        errors.add(:base, "Either product_id or user_id must be present")
      end
    end
  end