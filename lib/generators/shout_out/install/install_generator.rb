module ShoutOut
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_file
        template 'application_shout.rb', 'app/shouts/application_shout.rb'
      end

    end
  end
end