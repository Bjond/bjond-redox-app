# This migration comes from bjond_api_engine (originally 20160726222319)
class RenameEncryptionKeyColumn < ActiveRecord::Migration
  def change
    rename_column :bjond_registrations, :encryptionKey, :encrypted_encryption_key
  end
end
