# require 'explain_pattern/version'
require 'regexp_parser'
require 'tree_support'

module ExplainPattern
  class Tree
    # Creates a new regexp tree
    #
    # @param [String] regular expression
    def initialize(regexp)
      @regexp = Regexp::Parser.parse regexp
      display_tree
    end

    # Kicks off the tree construction
    #
    # @param [String] regular expression
    def struct
      tree = Node.new(@regexp) { traverse_exp @regexp }
      Node.clear_temp
      return tree
    end
    alias architecture struct

    # Displays the tree
    #
    def display_tree
      puts TreeSupport.tree architecture
    end

    # Creates each tree node
    #
    class Node
      attr_accessor :name, :parent, :children

      @temp = []

      class << self
        attr_accessor :temp

        def clear_temp
          @temp = []
        end
      end

      # Initializes each node of the tree
      #
      # @param [Regexp::Expression]
      # @param [Block] How the tree should be created
      # @example
      #   root = TreeSupport::Node.new("ROOT") do
      #       add "A" do
      #         add "B" do
      #           add "C"
      #         end
      #       end
      #     end
      #     puts TreeSupport.tree(root)
      #     > ROOT
      #     >  A
      #     >    B
      #     >      C
      def initialize(regexp, &block)
        @regexp   = regexp
        @name     = @regexp.to_s # Root of the tree
        @children = []
        @temp     = Node.temp
        instance_eval(&block) if block_given?
      end

      # Actively creates new nodes and assigns parents an children
      #
      def add(*args, &block)
        tap do
          children << self.class.new(*args, &block).tap do |instance|
            instance.parent = self
          end
        end
      end

      # Traverses each exp; creating new nodes
      #
      # @param [Regexp::Expression]
      def traverse_exp(regexp)
        regexp.traverse do |event, exp|
          unless @temp.include? exp
            add(exp) do
              @temp << exp
              traverse_exp exp if event == :enter
            end
          end
        end
      end
    end
  end
end
