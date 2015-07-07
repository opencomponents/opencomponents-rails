module OpenComponents::Rails
  class Railtie < ::Rails::Railtie
    config.opencomponents = ActiveSupport::OrderedOptions.new
    config.opencomponents.registry = OpenComponents::DEFAULT_REGISTRY

    initializer 'opencomponents.configure' do |app|
      OpenComponents.configure do |config|
        config.registry = app.config.opencomponents.registry
      end
    end

    initializer 'opencomponents.view_helpers' do
      ActionView::Base.send :include, OpenComponents::Rails::Renderer
    end
  end
end
