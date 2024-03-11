class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image do |attachable|
    attachable.variant(:display, resize_to_limit: [500, 500])
  end
  scope :newest, -> { order(created_at: :desc) }

  validates :content, presence: true, length: { maximum: Settings.LENGTH_140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png] }
end
