class RpIdForm
  include ActiveModel::Model

  attr_reader :service_url, :entity_id

  def initialize(hash) 
    @entity_id = hash[:entity_id]
    @service_url = hash[:service_url]
  end
  
end
