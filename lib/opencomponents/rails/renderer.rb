module OpenComponents::Rails
  module Renderer
    include ::OpenComponents::Renderer

    def render_component(component, params = {}, version = '')
      super(component, params, version).html_safe
    end
  end
end
