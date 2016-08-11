class BucketListSerializer < BaseSerializer
  has_many :items

  attributes :created_by
  
  def created_by
    object.user.name
  end
end
