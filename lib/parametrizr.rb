require 'parametrizr/version'
require 'parametrizr/permitter_finder'
require 'active_support/concern'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/introspection'
require 'active_support/dependencies/autoload'
require 'action_controller'

module Parametrizr
  # The Parametrizr module encapsulates all logic necessary to used
  # Parametrizr. Include it in a controller to expose the context_params
  # method.
  class NotDefinedError < StandardError; end
  class NoContextError < StandardError; end

  extend ActiveSupport::Concern
  class << self
    # Returns a permitter for the given user and parameter set, or nil if a
    # permitter class can't be found.
    def permitter(controller, user, params)
      permitter = PermitterFinder.new(controller).permitter
      permitter.new(user, params) if permitter
    end

    # Returns a permitter for the given user and parameter set, and raises
    # a NotDefinedError if a permitter class can't be found.
    def permitter!(controller, user, params)
      PermitterFinder.new(controller).permitter!.new(user, params)
    end
  end

  # The context_params returns a strong parameter hash based on the context of
  # the caller. It assumes that the parameter hash contains an :action
  # (or that one is explicitly passed), and the name of the controller. These
  # assumptions are satisfied automatically in rails.
  #
  # To contextualize parameters the method first looks for a permitter class
  # associated with the controller. Permitter classes are resolved using the
  # business logic encapsulated in Parametrizr::PermitterFinder.
  #
  # Once a permitter class is located context_params instantiates an instance
  # of the class passing in the parametrizr_user and the param set as arguments.
  # An method corresponding to the controller action is called on the instance,
  # if one exists, and the result is returned. If no such method exists, the
  # all_actions method is tried instead. If the instance fails to respond to
  # both the action and all_actions methods, a NoContextError is raised.
  def context_params(action = nil)
    context_permitter = permitter!
    action ||= params[:action].to_s
    if context_permitter.respond_to?(action)
      context_permitter.public_send(action)
    elsif context_permitter.respond_to?(:all_actions)
      context_permitter.public_send(:all_actions)
    else
      fail(NoContextError, "No context exists for action #{action}, and " \
        'no all_actions method was defined')
    end
  end

  # The user to pass when instantiating permitters.
  def parametrizr_user
    current_user
  end

  # Returns a permitter for the current param set, caching the result, and
  # raising a NotDefinedError if one is not found
  def permitter!
    permitters[params[:controller]] ||=
      Parametrizr.permitter!(self, parametrizr_user, params)
  end

  # Cache permitters across multiple calls
  def permitters
    @_parametrizr_permitters || {}
  end
end
