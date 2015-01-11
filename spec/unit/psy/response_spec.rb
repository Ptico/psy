RSpec.describe Psy::Response do
  let(:response) { described_class.new(env) }

  let(:env)    { Rack::MockRequest.env_for(path, method: method) }
  let(:path)   { '/' }
  let(:method) { 'GET' }

  let(:rack_tuple) { response.to_rack_array }

  let(:status)  { rack_tuple[0] }
  let(:headers) { rack_tuple[1] }
  let(:body)    { rack_tuple[2] }

  describe 'defaults' do
    it { expect(status).to  equal(200) }
    it { expect(headers).to eql({}) }
    it do
      body.each { |chunk| expect(chunk).to be(nil) }
    end
  end

  describe '#status=' do
    context 'when status registered' do
      before(:each) do
        response.status = 404
      end

      it { expect(status).to equal(404) }
    end

    xcontext 'when status not registered' do
      before(:each) do
        response.status = 777
      end

      it { pending }
    end
  end

  describe '#body=' do
    context 'single set' do
      before(:each) do
        response.body = 'Hello'
      end

      it { expect(body).to contain_exactly('Hello') }
    end

    context 'multiple set' do
      before(:each) do
        response.body = 'Hello'
        response.body = 'world'
      end

      it { expect(body).to contain_exactly('world') }
    end

    context 'array' do
      before(:each) do
        response.body = ['Hello', ' world']
      end

      it { expect(body).to contain_exactly('Hello', ' world') }
    end

    context 'when body is not allowed' do
      context 'by request method' do
        let(:method) { 'HEAD' }

        before(:each) do
          response.body = 'Hello'
        end

        it { expect(body).to be_empty }
      end

      context 'by response status' do
        context 'which was set before' do
          before(:each) do
            response.status = 204
            response.body = 'Hello'
          end

          it { expect(body).to be_empty }
        end

        context 'which has set after' do
          before(:each) do
            response.body = 'Hello'
            response.status = 204
          end

          it { expect(body).to be_empty }
        end
      end
    end
  end

  describe '#add_header' do
    before(:each) do
      response.add_header('Content-Type', 'application/json')
    end

    it { expect(headers).to eql('Content-Type' => 'application/json') }
  end

end
