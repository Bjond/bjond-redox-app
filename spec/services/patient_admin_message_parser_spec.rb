
require File.join(File.dirname(__FILE__), "../spec_helper")
require File.join(File.dirname(__FILE__), "../../app/services/patient_admin_message_parser")

describe PatientAdminMessageParser do
  
  it 'should return' do
    expect(PatientAdminMessageParser).to be_truthy
  end
end
