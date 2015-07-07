require 'opencomponents'

module OpenComponents::Rails
  class Railtie < ::Rails::Railtie
    config.opencomponents = ActiveSupport::OrderedOptions.new

    initializer 'opencomponents.configure' do |app|
      app.config.opencomponents.registry ||= OpenComponents::DEFAULT_REGISTRY

      OpenComponents.configure do |config|
        config.registry = app.config.opencomponents.registry
      end
    end

    initializer 'opencomponents.view_helpers' do
      ActionView::Base.send :include, OpenComponents::Rails::Renderer
    end
  end
end
