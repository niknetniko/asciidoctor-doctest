require 'active_support/core_ext/array/wrap'
require 'asciidoctor'
require 'asciidoctor/converter/template'

module Asciidoctor
  module DocTest
    ##
    # This class is basically a wrapper for +Asciidoctor.render+ that allows to
    # preset and validate some common parameters.
    class AsciidocRenderer

      attr_reader :backend_name, :converter, :template_dirs

      ##
      # @param backend_name [#to_s] the name of the tested backend.
      #
      # @param converter [Class, Asciidoctor::Converter::Base, nil]
      #        the backend's converter class (or its instance). If not
      #        specified, the default converter for the specified backend will
      #        be used.
      #
      # @param template_dirs [Array<String>, String] path of the directory (or
      #        multiple directories) where to look for the backend's templates.
      #        Relative paths are referenced from the working directory.
      #
      # @param templates_fallback [Boolean] allow to fall back to using an
      #        appropriate built-in converter when there is no required
      #        template in the tested backend?
      #        This is actually a default behaviour in Asciidoctor, but since
      #        it's inappropriate for testing of custom backends, it's disabled
      #        by default.
      #
      # @raise [ArgumentError] if some path from the +template_dirs+ doesn't
      #        exist or is not a directory.
      #
      def initialize(backend_name: nil, converter: nil, template_dirs: [], templates_fallback: false)
        @backend_name = backend_name.freeze
        @converter = converter
        @converter ||= TemplateConverterAdapter unless template_dirs.empty? || templates_fallback

        template_dirs = Array.wrap(template_dirs).freeze

        unless template_dirs.all? { |path| Dir.exist? path }
          raise ArgumentError, "Templates directory '#{path}' doesn't exist!"
        end
        @template_dirs = template_dirs unless template_dirs.empty?
      end

      ##
      # Renders the given +text+ in AsciiDoc syntax with Asciidoctor using the
      # tested backend.
      #
      # @param text [#to_s] the input text in AsciiDoc syntax.
      # @param opts [Hash] options to pass to Asciidoctor.
      # @return [String] rendered input.
      #
      def render(text, opts = {})
        renderer_opts = {
          safe: :safe,
          backend: backend_name,
          converter: converter,
          template_dirs: template_dirs,
        }.merge(opts)

        Asciidoctor.render(text.to_s, renderer_opts)
      end
    end

    ##
    # @private
    # Adapter for +Asciidoctor::Converter::TemplateConverter+.
    class TemplateConverterAdapter < SimpleDelegator

      # Placeholder to be written in a rendered output in place of the node's
      # content that cannot be rendered due to missing template.
      NOT_FOUND_MARKER = '--TEMPLATE NOT FOUND--'

      def initialize(backend, opts = {})
        super Asciidoctor::Converter::TemplateConverter.new(backend, opts[:template_dirs], opts)
      end

      ##
      # Delegates to the template converter and returns results, or prints
      # warning and returns {NOT_FOUND_MARKER} if there is no template to
      # handle the specified +template_name+.
      def convert(node, template_name = nil, opts = {})
        template_name ||= node.node_name

        if handles? template_name
          super
        else
          warn "Could not find a custom template to handle template_name: #{template_name}"
          NOT_FOUND_MARKER
        end
      end

      # Alias for backward compatibility.
      alias :convert_with_options :convert
    end
  end
end
