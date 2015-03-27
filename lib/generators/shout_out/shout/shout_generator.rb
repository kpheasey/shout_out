module ShoutOut
  module Generators
    class ShoutGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :model_name, type: :string

      def copy_file
        if model_name.underscore.include? '_shout'
          file = "app/shouts/#{model_name.underscore}.rb"
        else
          file = "app/shouts/#{model_name.underscore}_shout.rb"
        end

        template 'shout.rb', file
      end
      
    end
  end
end