require 'spec_helper'

RSpec.describe Parametrizr::PermitterFinder do
  context 'A controller class is given without a #permitter_class method' do
    let(:finder) { Parametrizr::PermitterFinder.new(ParametrizrController) }

    describe '#permitter' do
      it 'returns the ParametrizrPermitter' do
        expect(finder.permitter).to eq(ParametrizrPermitter)
      end
    end

    describe '#permitter!' do
      it 'returns the ParametrizrPermitter' do
        expect(finder.permitter!).to eq(ParametrizrPermitter)
      end
    end
  end

  context 'A controller class is given with a #permitter_class method' do
    let(:finder) do
      allow(ParametrizrController).to receive(:permitter_class)
        .and_return(NullPermitter)
      Parametrizr::PermitterFinder.new(ParametrizrController)
    end

    describe '#permitter' do
      it 'returns the NullPermitter' do
        expect(finder.permitter).to eq(NullPermitter)
      end
    end

    describe '#permitter!' do
      it 'returns the NullPermitter' do
        expect(finder.permitter!).to eq(NullPermitter)
      end
    end
  end

  context 'A controller instance is given with a #permitter_class method' do
    let(:finder) do
      allow(ParametrizrController).to receive(:permitter_class)
        .and_return(NullPermitter)
      user = double('user')
      params = double('params')
      Parametrizr::PermitterFinder.new(ParametrizrController.new(user, params))
    end

    describe '#permitter' do
      it 'returns the NullPermitter' do
        expect(finder.permitter).to eq(NullPermitter)
      end
    end

    describe '#permitter!' do
      it 'returns the NullPermitter' do
        expect(finder.permitter!).to eq(NullPermitter)
      end
    end
  end

  context 'A non-controller class is given without a #permitter_class method' do
    let(:finder) do
      user = double('user')
      params = double('params')
      Parametrizr::PermitterFinder.new(NonController.new(user, params))
    end

    describe '#permitter' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter).to eq(NonControllerPermitter)
      end
    end

    describe '#permitter!' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter!).to eq(NonControllerPermitter)
      end
    end
  end

  context 'A non-controller instance without a #permitter_class method' do
    let(:finder) { Parametrizr::PermitterFinder.new(NonController) }

    describe '#permitter' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter).to eq(NonControllerPermitter)
      end
    end

    describe '#permitter!' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter!).to eq(NonControllerPermitter)
      end
    end
  end

  context 'A non-controller class is given without a #permitter_class method' do
    let(:finder) { Parametrizr::PermitterFinder.new(NonController) }

    describe '#permitter' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter).to eq(NonControllerPermitter)
      end
    end

    describe '#permitter!' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter!).to eq(NonControllerPermitter)
      end
    end
  end

  context 'A non-controller instance that responds to controller_path' do
    let(:finder) do
      class FooClass
        def self.controller_path
          'non_controller'
        end
      end
      Parametrizr::PermitterFinder.new(FooClass.new)
    end

    describe '#permitter' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter).to eq(NonControllerPermitter)
      end
    end

    describe '#permitter!' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter!).to eq(NonControllerPermitter)
      end
    end
  end

  context 'A symbol is given' do
    let(:finder) { Parametrizr::PermitterFinder.new(:non_controller) }

    describe '#permitter' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter).to eq(NonControllerPermitter)
      end
    end

    describe '#permitter!' do
      it 'returns the NonControllerPermitter' do
        expect(finder.permitter!).to eq(NonControllerPermitter)
      end
    end
  end

  context 'An object, symbol, or class is given without a permitter class' do
    let(:finder) { Parametrizr::PermitterFinder.new(:foobar) }

    describe '#permitter' do
      it 'returns nil' do
        expect(finder.permitter).to be_blank
      end
    end

    describe '#permitter!' do
      it 'returns the NonControllerPermitter' do
        expect { finder.permitter! }
          .to raise_error(Parametrizr::NotDefinedError)
      end
    end
  end
end
