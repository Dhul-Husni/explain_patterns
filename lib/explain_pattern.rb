# require 'explain_pattern/version'
require_relative 'explain_pattern/references'
require 'regexp_parser'
require 'tree_support'

module ExplainPattern
  class Tree
    def initialize(regexp)
      @regexp = Regexp::Parser.parse regexp
      display_tree
    end

    def struct
      tree = Node.new(@regexp) { traverse_exp @regexp }
      Node.clear_temp
      tree
    end
    alias architecture struct

    def display_tree
      puts TreeSupport.tree architecture
    end

    class Node
      attr_accessor :name, :parent, :children

      @temp = []

      class << self
        attr_accessor :temp

        def clear_temp
          @temp = []
        end
      end

      def initialize(regexp, &block)
        @regexp   = regexp
        @name     = @regexp.to_s
        @children = []
        @temp     = Node.temp
        instance_eval(&block) if block_given?
      end

      def add(*args, &block)
        tap do
          children << self.class.new(*args, &block).tap do |instance|
            instance.parent = self
          end
        end
      end

      def traverse_exp(regexp)
        regexp.traverse do |event, exp|
          unless @temp.include? exp
            add(References.explain(exp)) do
              @temp << exp
              traverse_exp exp if event == :enter
            end
          end
        end
      end
    end
  end
end
