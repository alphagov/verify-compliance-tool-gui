require 'rails_helper'

describe RpMatchingForm do
  it 'should accept good inputs' do
    params = {
      expected_pid: 'a-pid',
      ms_entity_id: 'an-entity-id',
      ms_keystore_file: StringIO.new(good_keystore)
    }
    form = RpMatchingForm.new(params)
    expect(form.valid?).to eql(true)
  end

  it 'should reject an invalid keystore file' do
    params = {
      expected_pid: 'a-pid',
      ms_entity_id: 'an-entity-id',
      ms_keystore_file: StringIO.new(bad_keystore)
    }
    form = RpMatchingForm.new(params)
    expect(form.valid?).to eql(false)
    expect(form.errors[:ms_keystore_file].first).to eql('is not a DER-encoded PKCS8 keystore')
  end
end