class BucketList < ActiveRecord::Base
  has_many :items, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, uniqueness: true

  scope :search, ->(q) { where("name like ?", "%#{q}%") }
end
