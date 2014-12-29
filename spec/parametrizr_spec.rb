require 'spec_helper'

RSpec.describe Parametrizr do
  let(:user) { double }
  let(:params) do
    ActionController::Parameters.new(
      controller: 'parametrizr',
      action: 'update',
      object_params: { foo: 'f1', bar: 'b2' }
    )
  end
  let(:controller) { ParametrizrController.new(user, params) }

  describe 'Parametrizr#permitter' do
    it 'returns a permitter initialized with the user and params' do
      p = Parametrizr.permitter(controller, user, params)
      expect(p.user).to eq(user)
      expect(p.params).to eq(params)
    end

    it 'returns nil if a permitter is not found' do
      allow(ParametrizrController).to receive(:permitter_class)
        .and_return(nil)
      expect(Parametrizr.permitter(controller, user, params)).to be_blank
    end
  end

  describe 'Parametrizr#permitter!' do
    it 'returns a permitter initialized with the user and params' do
      p = Parametrizr.permitter!(controller, user, params)
      expect(p.user).to eq(user)
      expect(p.params).to eq(params)
    end

    it 'raises NotDefinedError if no permitter exists' do
      allow(ParametrizrController).to receive(:permitter_class)
        .and_return(nil)
      expect { Parametrizr.permitter!(controller, user, params) }
        .to raise_error(Parametrizr::NotDefinedError)
    end
  end

  describe '#parametrizr_user' do
    it 'returns the parametrizr_user' do
      expect(controller.parametrizr_user).to eq(user)
    end
  end

  describe '#permitter!' do
    it 'returns a permitter for the given param set' do
      expect(controller.permitter!.class).to eq(ParametrizrPermitter)
    end

    it 'raises NotDefinedError if no permitter exists' do
      allow(ParametrizrController).to receive(:permitter_class)
        .and_return(nil)
      expect { controller.permitter! }
        .to raise_error(Parametrizr::NotDefinedError)
    end

    it 'calls a contextual method if one exists' do
      res = controller.context_params
      expect(res[:foo]).to eq('f1')
      expect(res[:bar]).to be_blank
    end

    it 'defers to all_actions if an action does not exist' do
      params = ActionController::Parameters.new(
        controller: ParametrizrController,
        action: 'buzz',
        object_params: { foo: 'f1', bar: 'b2' }
      )
      controller = ParametrizrController.new(user, params)
      res = controller.context_params
      expect(res[:foo]).to eq('f1')
      expect(res[:bar]).to eq('b2')
    end

    it 'returns raises NoContextError if no action or all_actions method' do
      allow(ParametrizrController).to receive(:permitter_class)
        .and_return(NullPermitter)
      controller = ParametrizrController.new(user, params)
      expect { controller.context_params }
        .to raise_error(Parametrizr::NoContextError)
    end
  end
end
