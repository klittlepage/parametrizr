require 'simplecov'
SimpleCov.start

require 'active_support/dependencies/autoload'
require 'action_controller'
require 'parametrizr'

RSpec.configure

class ApplicationPermitter
  attr_reader :user, :params

  def initialize(user, params)
    @user, @params = user, params
  end
end

class ParametrizrPermitter < ApplicationPermitter
  def update
    params.require(:object_params).permit(:foo)
  end

  def all_actions
    params.require(:object_params).permit(:foo, :bar)
  end
end

class NonControllerPermitter < ApplicationPermitter; end

class NullPermitter < ApplicationPermitter; end

class ParametrizrController < ActionController::Base
  include Parametrizr

  attr_reader :current_user, :params

  def initialize(current_user, params)
    @current_user = current_user
    @params = params
  end
end

class NonController
  include Parametrizr

  attr_reader :current_user, :params

  def initialize(current_user, params)
    @current_user = current_user
    @params = params
  end
end
