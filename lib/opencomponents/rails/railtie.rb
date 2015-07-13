module OpenComponents::Rails
  class Railtie < ::Rails::Railtie
    config.opencomponents = ActiveSupport::OrderedOptions.new

    config.opencomponents.registry = OpenComponents::DEFAULT_REGISTRY
    config.opencomponents.enable_client_failover = true
    config.opencomponents.request_timeout = OpenComponents::DEFAULT_TIMEOUT

    initializer 'opencomponents.configure' do |app|
      OpenComponents.configure do |config|
        config.registry = app.config.opencomponents.registry
        config.timeout  = app.config.opencomponents.request_timeout
      end
    end

    initializer 'opencomponents.view_helpers' do
      ActionView::Base.send :include, OpenComponents::Rails::Renderer
    end
  end
end
