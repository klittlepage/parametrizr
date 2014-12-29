module Parametrizr
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__),
                                             'templates'))

      def copy_application_permitter
        template 'application_permitter.rb',
                 'app/permitters/application_permitter.rb'
      end
    end
  end
end
