require 'shout_out/version'
require 'active_support/concern'

module ShoutOut
  extend ActiveSupport::Concern

  included do
    before_validation -> { shout(:before_validation, self) }
    validate -> { shout(:validate, self) }
    after_validation -> { shout(:after_validation, self) }
    before_save -> { shout(:before_save, self) }
    after_save -> { shout(:after_save, self) }
    before_create -> { shout(:before_create, self) }
    after_create -> { shout(:after_create, self) }
    after_commit -> { shout(:after_commit, self) }
  end

  def shout(action, record)
    begin
      klass = "#{record.class.model_name}Shout".constantize
    rescue NameError
      return
    end

    klass.new(record).try(action)
  end
end

class ActiveRecord::Base
  include ShoutOut
end