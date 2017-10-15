module GCProfiler
  macro included
    def self.allocate
      ref = previous_def
      unless GCProfiler::Statistics.guard?
        GCProfiler::Statistics.guard=true
        callstack = CallStack.new
        GCProfiler::Statistics.on_allocation ref, callstack
        GCProfiler::Statistics.guard=false
      end
      ref
    end

    def finalize
      {% if @type.methods.includes? :finalize %}
        previous_def
      {% end %}
      unless GCProfiler::Statistics.guard?
        GCProfiler::Statistics.guard=true
        GCProfiler::Statistics.on_finalize self
        GCProfiler::Statistics.guard=false
      end
    end
  end
end
