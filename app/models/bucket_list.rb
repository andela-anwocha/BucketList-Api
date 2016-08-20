class BucketList < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :items, dependent: :destroy
  belongs_to :user

  scope :search, ->(query) do
    query = query.downcase if query
    where("lower(name) like ?", "%#{query}%")
  end

  scope :paginate, ->(page, page_limit) do
    page_limit = default_limit(page_limit.to_i)
    page_no = [page.to_i, 1].max - 1

    limit(page_limit).offset(page_limit.to_i * page_no)
  end

  def self.paginate_and_search(params)
    paginate(params[:page], params[:limit]).search(params[:q])
  end

  def self.default_limit(page_limit)
    page_limit = 20 if page_limit.zero?
    page_limit = 100 if page_limit > 100
    page_limit
  end
end
