require 'rely'

RSpec.describe 'Dependencies' do
  let(:abstract_service_class) {
    Class.new do
      extend Rely::Dependencies

      # Initialize the service, optionally setting dependency values.
      def initialize(dependencies={})
        dependencies.each do |attribute, value|
          send :"#{attribute}=", value if respond_to?(:"#{attribute}=", true)
        end
      end
    end
  }

  let(:service_class) {
    Class.new(abstract_service_class) do
      dependency :value, -> { :default }
      public :value
    end
  }

  let(:defaults) { {} }

  subject(:service) { service_class.new(defaults) }

  describe 'a dependency attribute' do
    it 'returns its default value' do
      expect(service.value).to eq :default
    end

    context 'when a value is injected' do
      let(:defaults) { { value: :injected } }

      it 'returns the injected value' do
        expect(service.value).to eq :injected
      end
    end
  end

  describe 'with a dynamic default value' do
    let(:service_class) {
      Class.new(abstract_service_class) do
        dependency :value, -> { Object.new }
        public :value
      end
    }

    it 'memoizes its default value' do
      value = service.value
      expect(service.value).to equal value
    end
  end

  describe 'with inter-dependency references' do
    let(:service_class) {
      Class.new(abstract_service_class) do
        dependency :value, -> { :default }
        dependency :dependent_value, -> { Struct.new(:value).new(value) }
        public :dependent_value
      end
    }

    subject(:service) { service_class.new(defaults) }

    it 'returns the injected value' do
      expect(service.dependent_value.value).to eq :default
    end
  end

  describe 'with inheritance' do
    let(:subservice_class) {
      Class.new(service_class) do
        dependency :another_value, -> { :another_default }
        public :another_value
      end
    }

    subject(:service) { subservice_class.new(defaults) }

    describe 'an ancestor’s dependency attribute' do
      it 'returns its default value' do
        expect(service.value).to eq :default
      end

      context 'when a value is injected' do
        let(:defaults) { { value: :injected } }

        it 'returns the injected value' do
          expect(service.value).to eq :injected
        end
      end
    end

    describe 'a dependency attribute' do
      it 'returns its default value' do
        expect(service.another_value).to eq :another_default
      end

      context 'when a value is injected' do
        let(:defaults) { { another_value: :another_injected } }

        it 'returns the injected value' do
          expect(service.another_value).to eq :another_injected
        end
      end
    end
  end
end
