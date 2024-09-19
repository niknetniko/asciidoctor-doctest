# frozen_string_literal: true

require 'asciidoctor/doctest/io/base'
require 'corefines'

using Corefines::Object[:blank?, :presence]
using Corefines::String.concat!

module Asciidoctor
  module DocTest
    module IO
      ##
      # Subclass of {IO::Base} for reference input examples.
      #
      # @example Format of the example's header
      #   // .example-name
      #   // Any text that is not the example's name or an option is considered
      #   // as a description.
      #   // :option_1: value 1
      #   // :option_2: value 1
      #   // :option_2: value 2
      #   // :boolean_option:
      #   The example's content in *AsciiDoc*.
      #
      #   NOTE: The trailing new line (below this) will be removed.
      #
      class Asciidoc < Base
        def parse(input, group_name)
          examples = []
          current = create_example(nil)

          input.each_line do |line|
            case line.chomp!
            when %r{^//\s*\.([^ \n]+)}
              local_name = ::Regexp.last_match(1)
              current.content.chomp!
              examples << (current = create_example([group_name, local_name]))
            when %r{^//\s*:([^:]+):(.*)}
              current[::Regexp.last_match(1).to_sym] =
                ::Regexp.last_match(2).blank? ? true : ::Regexp.last_match(2).strip
            when %r{^//\s*(.*)\s*$}
              (current.desc ||= '').concat!(::Regexp.last_match(1), "\n")
            else
              current.content.concat!(line, "\n")
            end
          end

          examples
        end

        def serialize(examples)
          Array(examples).map do |exmpl|
            [].push(".#{exmpl.local_name}")
              .push(*exmpl.desc.lines.map(&:chomp))
              .push(*format_options(exmpl.opts))
              .map { |s| "// #{s}" }
              .push(exmpl.content.presence)
              .compact
              .join("\n")
              .concat("\n")
          end.join("\n")
        end
      end
    end
  end
end
