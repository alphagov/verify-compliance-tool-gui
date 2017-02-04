class RpIdForm
  include ActiveModel::Model

  attr_reader :service_url, :entity_id
  validates :service_url, :entity_id, presence: true

  # Half heartedly check that these are absolute URLs by checking they contain "://"
  validates :service_url, :entity_id, format: { with: /:\/\// }

  def initialize(hash) 
    @entity_id = hash[:entity_id]
    @service_url = hash[:service_url]
  end
  
end
