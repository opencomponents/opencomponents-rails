# OpenComponents::Rails
[![Build Status](https://travis-ci.org/opentable/opencomponents-rails.svg?branch=master)][1]
[![Gem Version](https://badge.fury.io/rb/opencomponents-rails.svg)][2]

[1]:https://travis-ci.org/opentable/opencomponents-rails
[2]:http://badge.fury.io/rb/opencomponents-rails

OpenComponents for Rails. This gem provides view helper methods for component
rendering on both server- and client-side.

## Getting Started
Add the gem to your Gemfile and run `bundle install`:

```ruby
gem 'opencomponents-rails'
```

### Configuration
All configuration options are set through Rails environment configuration files.

```ruby
# production.rb

# Sets the registry URL to fetch components from. Defaults to http://localhost:3030.
config.opencomponents.registry = 'http://my.awesome.registry'

# Determines whether rendering should be handed off to the browser if server-side
# rendering fails. Defaults to true.
config.opencomponents.enable_client_failover = true

# Sets the timeout length (in seconds) for registry requests. Defaults to 5.
config.opencomponents.request_timeout = 10
```

## Rendering
`OpenComponents::Rails` supports both server- and client-side rendering of components.
By default, the gem will fall back to client-side rendering if a server-side registry
request times out. If client-side failover if disabled, an error will be raised instead.
This is configurable using the `enable_client_failover` option.

### Client-Side Rendering
The OpenComponents client-side javascript library is bundled with this gem for inclusion
in the asset compilation process. To enable client-side rendering through the asset
pipeline, add the library to your javascript manifest:

```javascript
//= require opencomponents
```

Once that's done, you can use the `oc_component_tag` method in your views. You can either
pass the method a fully formed `href` attribute or use the same options as `OpenComponents`
[Renderer][3].
```erb
<%= oc_component_tag('my-sweet-component', href: 'http://localhost:3030/my-sweet-component/1.0.1?name=Zan') %>

<%= oc_component_tag('my-sweet-component', params: {name: 'Zan'}, version: '1.0.1') %>
```

Components using this tag will be automatically rendered on DOM load.

### Server-Side Rendering
In your view, simply call `render_component`:

```erb
<%= render_component('my-sweet-component', params: {name: 'Zan'}, version: '1.0.1') %>
```

The method accepts the same options as the `OpenComponents` [Renderer][3].

[3]:http://www.rubydoc.info/gems/opencomponents/OpenComponents/Renderer

## Contributing
Would be pretty cool of you. Open an Issue or PR if you find bugs or have ideas for improvements.

## License
Copyright 2015 OpenTable. See LICENSE for details.
