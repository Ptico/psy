RSpec.describe Psy::Controller::Base do
  subject { described_class.call(env) }

  let(:env)    { Rack::MockRequest.env_for(path, method: method) }
  let(:path)   { '/' }
  let(:method) { 'GET' }

  describe '.call' do
    let(:response) { instance_double('Psy::Response', to_rack_array: [200, {}, []]) }

    before(:each) do
      allow(Psy::Response).to receive(:new).with(env).and_return(response)
    end

    xit 'calls instance method #call' do

    end

    it 'returns result of response' do
      expect(subject).to contain_exactly(200, {}, [])
    end
  end

end
