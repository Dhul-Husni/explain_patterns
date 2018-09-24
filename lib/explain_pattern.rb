require "explain_pattern/version"
require "regexp_pattern"
require "terminal-table/import"

module ExplainPattern

  regex = /a?(b+(c)d)*(?<name>[0-9]+)(?=abc)/

  module Tree
    tree = Regexp::Parser.parse(regex)
  end

  module Table
  end

  class String
  end
end