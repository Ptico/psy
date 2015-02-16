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

  describe '#status' do
    context 'as getter' do
      before(:each) do
        response.status = 403
      end

      it { expect(response.status.code).to equal(403) }
      it { expect(response.status.type).to equal(:client_error) }
    end

    context 'as setter' do
      before(:each) do
        response.status(403)
      end

      it { expect(status).to equal(403) }
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
      context 'when all elements is a strings' do
        before(:each) do
          response.body = ['Hello', ' world']
        end

        it { expect(body).to eql(['Hello', ' world']) }
      end

      xcontext 'when some elements is not strings' do
        before(:each) do
          response.body = ['I', :have, 2, 'dogs']
        end

        it { expect(body).to eql(['I', 'have', '2', 'dogs']) }
      end
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

  describe '#body' do
    context 'as getter' do
      before(:each) do
        response.body = 'The body'
      end

      it { expect(response.body).to contain_exactly('The body') }
    end

    context 'as setter' do
      before(:each) do
        response.body('Тело ответа')
      end

      it { expect(body).to contain_exactly('Тело ответа') }
    end
  end

  describe '#body_string' do
    before(:each) do
      response.body = ['Hello', ' world']
    end

    it { expect(response.body_string).to eql('Hello world') }
  end

  describe '#add_header' do
    before(:each) do
      response.add_header('X-Auth-Token', 'cbe34ae2e')
    end

    it { expect(headers).to eql('X-Auth-Token' => 'cbe34ae2e') }
  end

  describe '#headers' do
    before(:each) do
      response.add_header('X-Auth-Token', 'b902b2c3a')
    end

    it { expect(response.headers).to eql('X-Auth-Token' => 'b902b2c3a') }
  end

  describe '#body_allowed?' do
    subject { response.body_allowed? }

    context 'when body allowed' do
      it { expect(subject).to be(true) }
    end

    context 'when body does not allowed' do
      context 'by request method' do
        let(:method) { 'HEAD' }

        it { expect(subject).to be(false) }
      end

      context 'by response status' do
        before(:each) do
          response.status = 204
        end

        it { expect(subject).to be(false) }
      end
    end
  end

  describe '#normalize!' do
    describe 'Content-Length' do
      context 'when Content-Type was set' do
        before(:each) do
          response.add_header('Content-Type', 'text/html')
        end

        context 'and body is not empty' do
          before(:each) do
            response.body = ['<h2>', 'Привет мир', '</h2>']
          end

          it 'should calculate content length' do
            expect(headers['Content-Length']).to eql('28')
          end
        end

        context 'and body is empty' do
          it 'must be 0' do
            expect(headers['Content-Length']).to eql('0')
          end
        end

        context 'and body is not allowed' do
          let(:method) { 'HEAD' }

          it 'does not set Content-Type header' do
            expect(headers).to_not have_key('Content-Length')
          end
        end
      end

      context 'when body does not allowed' do
        before(:each) do
          response.status = 204
          response.add_header('Content-Length', '100')
        end

        it 'drops Content-Length header' do
          expect(headers).to_not have_key('Content-Length')
        end
      end
    end

    describe 'Content-Type' do
      context 'when body does not allowed' do
        before(:each) do
          response.status = 204
          response.add_header('Content-Type', 'text/html')
        end

        it 'drops Content-Type header' do
          expect(headers).to_not have_key('Content-Type')
        end
      end
    end

    describe 'response body' do
      context 'when body does not allowed' do
        before(:each) do
          response.status = 204
          response.body << 'foo'
        end

        it 'drops body' do
          expect(body).to be_empty
        end
      end
    end

  end

end
