class RedoxConfiguration < ActiveRecord::Base
  belongs_to :bjond_registration

  def self.destroy_unused_configurations
    RedoxConfiguration.all.each do |c|
      if c.bjond_registration.nil?
        c.destroy
      end
    end
  end
end
