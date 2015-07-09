module OpenComponents::Rails
  module Renderer
    include ::OpenComponents::Renderer

    include ActionView::Helpers::TagHelper

    def render_component(component, opts = {})
      super(component, opts).html_safe
    rescue OpenComponents::RegistryTimeout => e
      config = ::Rails.application.config.opencomponents

      raise unless config.enable_client_failover

      oc_component_tag(component, opts)
    end

    def oc_component_tag(component, opts = {})
      opts = opts.with_indifferent_access
      options = opts.reject { |k, _| %w(params version).include? k }

      unless options[:href]
        registry = ::Rails.application.config.opencomponents.registry

        options[:href] = File.join(
          registry, component, opts[:version].to_s
        )

        options[:href] << "?#{opts[:params].to_param}" if opts[:params]
      end

      tag('oc-component', options)
    end
  end
end
