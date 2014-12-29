module Parametrizr
  class PermitterFinder
    # PermitterFinder attempts to locate a permitter class given a class,
    # instance, symbol, or string denoting the permitter to return.
    # If the class or instance given responds to the permitter_class
    # method, the value returned by permitter_class will take precedence over
    # any other interpretation
    attr_reader :object

    # Initialize with an arbitrary object that will be used to determine the
    # permitter class returned by #permitter permitter!
    def initialize(object)
      @object = object
    end

    # Returns the appropriate permitter class, or nil if no such
    def permitter
      klass = find
      klass = klass.constantize if klass.is_a?(String)
      klass
    rescue NameError
      nil
    end

    # Returns a permitter if one is found, and raises a NotDefinedError
    # otherwise.
    def permitter!
      permitter || fail(NotDefinedError,
                        "unable to find permitter #{find} for #{object}")
    end

    private

    # Find a permitter. First check to see if the object given responds to
    # permitter_class. If it does, use the value returned. Otherwise,
    # search for a class.
    def find
      if object.respond_to?(:permitter_class)
        object.permitter_class
      elsif object.class.respond_to?(:permitter_class)
        object.class.permitter_class
      else
        find_implicit
      end
    end

    # Search for a permitter. First, check if the object given is
    # "controller-like," and responds to controller_path. If it is, use the
    # controller path as the base. Otherwise, depending on whether
    # we're given a class, a symbol, or something else, normalize the the name
    # to a candidate class.
    def find_implicit
      klass = find_for_controller
      return klass if klass
      klass = if object.is_a?(Class)
                object
              elsif object.is_a?(Symbol)
                object.to_s.classify
              else
                object.class
              end
      "#{klass}Permitter"
    end

    def find_for_controller
      if object.respond_to?(:controller_path)
        permitter_for_path(object.controller_path)
      elsif object.class.respond_to?(:controller_path)
        permitter_for_path(object.class.controller_path)
      end
    end

    def permitter_for_path(path)
      "#{path}_permitter".classify
    end
  end
end
