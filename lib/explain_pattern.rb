require 'explain_pattern/version'
require 'regexp_parser'
require 'tree_support'

module ExplainPattern

  def identify regexp
  end

  class Tree
    @temp = []

    class << self

      def clear_temp
        @temp = []
      end
    end

    def initialize(regexp)
      @regexp = Regexp::Parser.parse regexp
      display_tree
    end

    def display_tree
      struct = Node.new(@regexp) { traverse_tree @regexp }
      puts TreeSupport.tree struct
      Tree.clear_temp
    end

    class Node

      def initialize(regexp, &block)
        @regexp = regexp
        @name = @regexp.to_s
        @children = []
        @temp = Tree.temp
        instance_eval(&block) if block_given?
      end

      def add(*args, &block)
        tap do
          children << self.class.new(*args, &block).tap do |instance|
             instance.parent = self
          end
        end
      end

      def traverse_tree(exp)
        exp.traverse do |event, exp|
          unless @temp.include? exp
            add(exp) do
              @temp << exp
              traverse_tree exp if event == :enter
            end
          end
        end
      end
    end
  end
end