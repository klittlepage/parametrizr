module Parametrizr
  module Generators
    class PermitterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__),
                                             'templates'))

      def create_permitter
        template 'permitter.rb', File.join('app/permitters', class_path,
                                           "#{file_name}_permitter.rb")
      end
    end
  end
end
