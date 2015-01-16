RSpec.describe Psy::Environment do
  let(:instance) do
    described_class.new(name, parent) do
      set(:app_name, 'MyApp')
      set(:vars, hello: 'world', foo: 'bar')
    end
  end
  let(:result) { instance.build }

  let(:name)   { :default }
  let(:parent) { nil }

  describe '#set' do
    context 'simple value' do
      subject { result.app_name }

      it { expect(subject).to eql('MyApp') }
    end

    context 'hash value' do
      subject { result.vars }

      it { expect(subject).to eql(hello: 'world', foo: 'bar') }
    end

    context 'block'
  end
end
