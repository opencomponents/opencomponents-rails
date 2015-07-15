module OpenComponents::Rails
  module Renderer
    include ::OpenComponents::Renderer

    include ::ActionView::Helpers::TagHelper

    # Returns a rendered component.
    #
    #   render_component('my-component')
    #   # => <oc-component href="http://localhost:3030/my-component">...</oc-component>
    #
    # Also accepts options for "params", "version", and "headers".
    #
    #   render_component('my-component',
    #     params: {name: 'Zan'},
    #     version: '1.0.2',
    #     headers: {accept_language: 'emoji'}
    #   )
    #   # => <oc-component href="http://localhost:3030/my-component/1.0.2?name=Zan">...</oc-component>
    #
    # Raises an error if the registry request times out and client failover is
    # disabled, otherwise will return an unrendered <oc-component> tag for
    # client-side rendering.
    def render_component(component, opts = {})
      super(component, opts).html_safe
    rescue OpenComponents::RegistryTimeout
      config = ::Rails.application.config.opencomponents

      raise unless config.enable_client_failover

      oc_component_tag(component, opts)
    end

    # Returns an unrendered oc-component tag for client-side rendering.
    #
    #   oc_component_tag('my-component')
    #   # => <oc-component href="localhost:3030/my-component" />
    #
    # Also accepts options for "href", "params", and "version". "params" and
    # "version" are ignored if "href" is passed to the method. If no href is
    # passed, the method attempts to build a valid URL using the configured
    # OC registry, component name, and params and version if they're available.
    #
    #   oc_component_tag('my-component', params: {name: 'Zan'}, version: '1.0.2')
    #   # => <oc-component href="http://localhost:3030/my-component/1.0.2?name=Zan" />
    #
    #   oc_component_tag('my-component', href: 'http://some.registry/my-component')
    #   # => <oc-component href="http://some.registry/my-component" />
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
