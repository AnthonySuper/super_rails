# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

require "active_model"
require "active_model/serializers/json"

##
# Overall module of the library.
module SuperSerializer
end
