class RpMatchingForm
  include ActiveModel::Model

  attr_reader :ms_keystore_file, :expected_pid, :ms_entity_id
  validates :ms_keystore_file, :expected_pid, :ms_entity_id, presence: true
  validates :ms_keystore_file, keystore: true

  def initialize(hash) 
    @expected_pid = hash[:expected_pid]
    @ms_entity_id = hash[:ms_entity_id]
    @ms_keystore_file = hash[:ms_keystore_file]
  end

  def ms_keystore
    Base64.strict_encode64(@ms_keystore_file.read)
  end
end
