
require File.join(File.dirname(__FILE__), "../spec_helper")
require File.join("#{RAILS_APP_DIRECTORY}/services/patient_admin_message_parser")

describe PatientAdminMessageParser do
  it 'should load' do
    expect(PatientAdminMessageParser).to be_truthy
  end


  context 'event_data_from_json' do

    context 'patient arrival message' do
      before(:each) do
        @raw_json_1 = File.read("#{FIXTURES_DIRECTORY}/patient_arrival_1.json")
      end

      it 'should properly parse eventType' do
        event_data = PatientAdminMessageParser.event_data_from_json(@raw_json_1)
        expect(event_data[:eventType]).to eq("Arrival")
      end

      describe 'diagnosesCodes' do
        it 'should parse diagnosesCodes' do
          event_data = PatientAdminMessageParser.event_data_from_json(@raw_json_1)
          expect(event_data[:diagnosesCodes]).to eq(["R07.0"])
        end

        it 'should parse multiple diagnosesCodes' do
          raw_json_multiple_codes = File.read("#{FIXTURES_DIRECTORY}/patient_arrival_multiple_codes.json")
          event_data = PatientAdminMessageParser.event_data_from_json(raw_json_multiple_codes)
          expect(event_data[:diagnosesCodes]).to eq(["N39.0", "L20.84"])
        end
      end

      it 'should parse servicingFacility' do
        event_data = PatientAdminMessageParser.event_data_from_json(@raw_json_1)
        expect(event_data[:servicingFacility]).to eq("RES General Hospital")
      end

      it 'should parse sex' do
        event_data = PatientAdminMessageParser.event_data_from_json(@raw_json_1)
        expect(event_data[:sex]).to eq("Male")
      end

      it 'should parse reason as discharge disposition' do
        event_data = PatientAdminMessageParser.event_data_from_json(@raw_json_1)
        expect(event_data[:dischargeDisposition]).to eq("Check up")
      end
    end


  end
end
