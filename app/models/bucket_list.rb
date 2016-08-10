class BucketList < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :items, dependent: :destroy
  belongs_to :user

  scope :search, ->(q) { where("name like ?", "%#{q}%") }

  scope :paginate, lambda { |page, page_limit|
    limit(page_limit).offset(page_limit.to_i * ([page.to_i, 1].max - 1))
  }

  def self.paginate_and_search(params)
    paginate(params[:page], params[:limit]).search(params[:q])
  end
end
