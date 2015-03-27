class <%= model_name.underscore.include?('_shout') ? model_name : "#{model_name}Shout" %> < ApplicationShout

end