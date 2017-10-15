module Trashman
  macro included
    def self.allocate
      ref = previous_def
      unless Trashman::Statistics.guard?
        Trashman::Statistics.guard=true
        callstack = CallStack.new
        Trashman::Statistics.on_allocation ref, callstack
        Trashman::Statistics.guard=false
      end
      ref
    end

    def finalize
      {% if @type.methods.includes? :finalize %}
        previous_def
      {% end %}
      unless Trashman::Statistics.guard?
        Trashman::Statistics.guard=true
        Trashman::Statistics.on_finalize self
        Trashman::Statistics.guard=false
      end
    end
  end
end
