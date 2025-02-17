# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

##
# Base namespace module for the library.
module SuperTyped
end
