require 'spec_helper'

RSpec.describe OpenComponents::Rails::Renderer do
  class TestRenderer
    include OpenComponents::Rails::Renderer
  end

  describe '#render_component' do
    subject { TestRenderer.new.render_component('foobar', params: {name: 'todd'}) }

    context 'valid request' do
      before do
        stub_request(:get, "http://localhost:3030/foobar/?name=todd").
          with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => '{"href":"http://localhost:3030/foobar?name=todd","type":"oc-component-local","version":"1.0.0","requestVersion":"","html":"<oc-component href=\"http://localhost:3030/foobar?name=todd\" data-hash=\"0fe4b3fb2d6c0810f0d97a222a7e61eb91243bea\" id=\"8502960618\" data-rendered=\"true\" data-version=\"1.0.0\"><h1>ohai, my name is foobar</h1></oc-component>","renderMode":"rendered"}', :headers => {})
      end

      it 'returns the HTML string' do
        expect(subject).to eq "<oc-component href=\"http://localhost:3030/foobar?name=todd\" data-hash=\"0fe4b3fb2d6c0810f0d97a222a7e61eb91243bea\" id=\"8502960618\" data-rendered=\"true\" data-version=\"1.0.0\"><h1>ohai, my name is foobar</h1></oc-component>"
      end

      it 'is html_safe' do
        expect(subject.html_safe?).to be true
      end
    end

    context 'registry timeout' do
      before do
        stub_request(:get, "http://localhost:3030/foobar/?name=todd").to_timeout

        allow(Rails).to receive_message_chain(
          'application.config.opencomponents.registry'
        ) { OpenComponents::DEFAULT_REGISTRY }
      end

      it 'raises an error if client failover is disabled' do
        allow(Rails).to receive_message_chain(
          'application.config.opencomponents.enable_client_failover'
        ) { false }

        expect { subject }.to raise_error OpenComponents::RegistryTimeout
      end

      it 'returns an oc-component tag for client side rendering' do
        allow(Rails).to receive_message_chain(
          'application.config.opencomponents.enable_client_failover'
        ) { true }

        expect(subject).to eq "<oc-component href=\"http://localhost:3030/foobar/?name=todd\" />"
      end
    end
  end

  describe '#oc_component_tag' do
    before do
      allow(Rails).to receive_message_chain(
        'application.config.opencomponents.registry'
      ) { OpenComponents::DEFAULT_REGISTRY }
    end

    subject { TestRenderer.new.oc_component_tag('foobar', options) }

    context 'with href option' do
      let(:options) { {href: 'http://some.registry.com/foobar?name=todd'} }

      it 'returns the oc-component tag with the defined href attribute' do
        expect(subject).to eq "<oc-component href=\"http://some.registry.com/foobar?name=todd\" />"
      end
    end

    context 'without href option' do
      let(:options) { {params: {name: 'todd'}, version: '1.0.2'} }

      it 'returns the oc-component tag with the href built from options' do
        expect(subject).to eq "<oc-component href=\"http://localhost:3030/foobar/1.0.2?name=todd\" />"
      end
    end
  end
end
