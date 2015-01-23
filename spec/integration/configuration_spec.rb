RSpec.describe Psy::Configuration::Builder do
  let(:instance) do
    described_class.new(parent) do
      set(:app_name, 'MyApp')
      set(:vars, hello: 'world', foo: 'bar')

      environment :development do
        set(:app_name, 'YourApp')
        set(:handler, :dev)
      end
    end
  end
  let(:result) { instance.build(env) }

  let(:name)   { :default }
  let(:parent) { nil }

  describe '#logger' do
    subject { instance.logger(logger) }

    let(:env) { :development }

    let(:stubs) do
      { log: true, debug: true, info: true, warn: true, error: true, fatal: true }
    end

    context 'when responds to #log, #debug, #info, #warn, #error, #fatal' do
      let(:logger) { instance_double('Logger', stubs) }

      it { expect { subject }.to_not raise_error }
    end

    %i(log debug info warn error fatal).each do |severity|
      context "when does not responds to ##{severity}" do
        let(:logger) do
          double(stubs.tap { |s| s.delete(severity) })
        end

        it 'raises error' do
          expect { subject }.to raise_error(Psy::Configuration::InvalidLoggerError, "logger must respond to ##{severity}")
        end
      end
    end

    context 'when not given' do
      it 'initializes stdlib Logger' do
        expect(result.logger).to be_instance_of(Logger)
      end

      it 'writes to $stdout' do
        expect { result.logger.log(0, 'foo') }.to output(/foo/).to_stdout
      end
    end
  end

  describe '#params_hash' do

  end

  describe '#set' do
    context 'simple value' do
      context 'when environment not specified' do
        let(:env) { :production }

        it 'returns value' do
          expect(result.app_name).to eql('MyApp')
        end
      end

      context 'when environment specified' do
        let(:env) { :development }

        context 'key was set in default env' do
          subject { result.app_name }

          it 'overwrites value' do
            expect(subject).to eql('YourApp')
          end
        end

        context 'key was not set in default env' do
          subject { result.handler }

          it 'returns value' do
            expect(subject).to equal(:dev)
          end
        end
      end

      context 'when parent given' do
        let(:parent) do
          described_class.new do
            set(:app_name, 'BaseApp')
            set(:app_path, '/app')
          end.build(env)
        end
        let(:env) { :production }

        context 'not defined in child' do
          subject { result.app_path }

          it 'returns parents value' do
            expect(subject).to eql('/app')
          end
        end

        context 'defined in child' do
          subject { result.app_name }

          it 'returns child value' do
            expect(subject).to eql('MyApp')
          end
        end

        context 'defined in child and environment' do
          subject { result.app_name }

          let(:env) { :development }

          it 'returns environment value' do
            expect(subject).to eql('YourApp')
          end
        end
      end
    end

    context 'hash value' do
      subject { result.vars }
      let(:env) { :development }

      it { expect(subject).to eql(hello: 'world', foo: 'bar') }
    end

    context 'block'
  end
end
