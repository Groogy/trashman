module Trashman
  macro included
    {% if Trashman::Config::IS_ENABLED %}
      def self.allocate
        ref = previous_def
        \{% if !@type.annotation(Trashman::Ignore) && !@type.type_vars.any? &.annotation(Trashman::Ignore) %}
          unless Trashman::Statistics.guard?
            begin
              Trashman::Statistics.guard = true
              callstack = CallStack.new
              Trashman::Statistics.on_allocation ref, callstack
            ensure
              Trashman::Statistics.guard = false
            end
          end
        \{% end %}
        ref
      end

      def finalize
        \{% if @type.methods.includes? :finalize %}
          previous_def
        \{% end %}
        \{% if !@type.annotation(Trashman::Ignore) && !@type.type_vars.any? &.annotation(Trashman::Ignore) %}
          unless Trashman::Statistics.guard?
            begin
              Trashman::Statistics.guard = true
              Trashman::Statistics.on_finalize self
            ensure
              Trashman::Statistics.guard = false
            end
          end
        \{% end %}
      end
    {% end %}
  end
end
