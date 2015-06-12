require 'shout_out/version'
require 'active_support/concern'

module ShoutOut
  extend ActiveSupport::Concern

  included do
    after_initialize -> { shout(:after_initialize, self) }
    after_find -> { shout(:after_find, self) }
    after_touch -> { shout(:after_touch, self) }
    before_validation -> { shout(:before_validation, self) }
    validate -> { shout(:validate, self) }
    after_validation -> { shout(:after_validation, self) }
    before_save -> { shout(:before_save, self) }
    around_save -> { shout(:around_save, self) }
    after_save -> { shout(:after_save, self) }
    before_create -> { shout(:before_create, self) }
    around_create -> { shout(:around_create, self) }
    after_create -> { shout(:after_create, self) }
    before_update -> { shout(:before_update, self) }
    around_update -> { shout(:around_update, self) }
    after_update -> { shout(:after_update, self) }
    before_destroy -> { shout(:before_destroy, self) }
    around_destroy -> { shout(:around_destroy, self) }
    after_destroy -> { shout(:after_destroy, self) }
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
