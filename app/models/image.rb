class Image < ActiveRecord::Base
    dragonfly_accessor :image
  
    validates :image, presence: true
    validates :product_id, presence: true
    validates :user_id, presence: true

    validates_size_of :image, maximum: 1.megabytes,
                      message: "should be no more than 500 KB", if: :image_changed?
  
    validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false,
                       message: "should be either .jpeg, .jpg, .png, .bmp", if: :image_changed?


    belongs_to :product
    belongs_to :user
  end