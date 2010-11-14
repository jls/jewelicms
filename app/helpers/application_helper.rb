module ApplicationHelper
  def select_options collection, id = "id", name = "name"
    options_from_collection_for_select(collection, id, name)
  end
end
