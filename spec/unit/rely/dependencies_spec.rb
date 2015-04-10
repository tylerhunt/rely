require 'rely/dependencies'

module Rely
  RSpec.describe Dependencies do
    let(:service_class) {
      Class.new do
        extend Rely::Dependencies
      end
    }

    describe '.dependency' do
      it 'defines a new attribute reader' do
        expect { service_class.dependency :value, -> { :default } }
          .to change { service_class.new.respond_to?(:value, true) }
      end

      it 'defines a new attribute writer' do
        expect { service_class.dependency :value, -> { :default } }
          .to change { service_class.new.respond_to?(:value=, true) }
      end

      it 'provides a default value for the attribute' do
        service_class.dependency :value, -> { :default }
        expect(service_class.new.send(:value)).to eq :default
      end
    end

    describe '.dependencies' do
      before do
        service_class.dependency :value, -> { :default }
        service_class.dependency :another_value, -> { :default }
      end

      it 'returns the names of the dependency attributes' do
        expect(service_class.dependencies).to match [:value, :another_value]
      end
    end
  end
end
