class BaseSerializer < ActiveModel::Serializer
  attributes :id, :name, :date_created, :date_modified
  def date_created
    DateTime.parse(object.created_at.to_s).strftime("%Y-%m-%d %H:%M:%S")
  end

  def date_modified
    DateTime.parse(object.updated_at.to_s).strftime("%Y-%m-%d %H:%M:%S")
  end
end
