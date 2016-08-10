class BucketList < ActiveRecord::Base
  has_many :items, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  belongs_to :user
end
