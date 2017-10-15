module Trashman::Config
  {% if flag?(:ENABLE_TRASHMAN) && flag?(:release) == false %}
    IS_ENABLED = true
  {% else %}
    IS_ENABLED = false
  {% end %}
end
