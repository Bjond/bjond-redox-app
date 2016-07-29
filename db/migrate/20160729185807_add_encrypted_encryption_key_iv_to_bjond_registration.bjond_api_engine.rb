# This migration comes from bjond_api_engine (originally 20160726225852)
class AddEncryptedEncryptionKeyIvToBjondRegistration < ActiveRecord::Migration
  def change
    add_column :bjond_registrations, :encrypted_encryption_key_iv, :string
  end
end
