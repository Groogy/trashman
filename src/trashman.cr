require "./trashman/annotations.cr"
require "./trashman/config.cr"
require "./trashman/*"

module Trashman
  # Now we can start tracking data
  Statistics.guard = false
end
