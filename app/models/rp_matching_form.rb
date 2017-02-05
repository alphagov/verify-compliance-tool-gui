class RpMatchingForm
  include ActiveModel::Model

  attr_reader :ms_keystore, :expected_pid, :ms_entity_id
  validates :ms_keystore, :expected_pid, :ms_entity_id, presence: true
  validates :ms_entity_id, format: { with: /:\/\// }
  validates :ms_keystore, format: { with: /\A[A-Za-z0-9\/+=]+\s*\Z/ }

  def initialize(hash) 
    @expected_pid = hash[:expected_pid]
    @ms_entity_id = hash[:ms_entity_id]
    @ms_keystore = hash[:ms_keystore]
  end

  def self.normalize_keystore(input)
    # The compliance expects a base64 encoded keystore, but we allow trailing whitespace
    # in the form for the user's convenience. This method strips the whitespace so the keystore
    # is in the format expeted by compliance tool.
    if input.nil?
      nil
    else
      input.sub(/\s+\Z/, '')
    end
  end
end
