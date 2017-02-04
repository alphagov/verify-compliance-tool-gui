class RpMatchingForm
  include ActiveModel::Model

  attr_reader :ms_keystore, :expected_pid, :ms_entity_id

  def initialize(hash) 
    @expected_pid = hash[:expected_pid]
    @ms_entity_id = hash[:ms_entity_id]
    @ms_keystore = hash[:ms_keystore]
  end
end
