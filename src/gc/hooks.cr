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
      #previous_def
      unless GCProfiler::Statistics.guard?
        GCProfiler::Statistics.guard=true
        GCProfiler::Statistics.on_finalize self
        GCProfiler::Statistics.guard=false
      end
    end
  end
end


module GC
  def self.malloc(size : Int)
    ptr = previous_def
    unless GCProfiler::Statistics.guard?
      GCProfiler::Statistics.guard=true
      callstack = CallStack.new
      GCProfiler::Statistics.on_allocation ptr, callstack
      GCProfiler::Statistics.guard=false
    end
    ptr
  end
end
