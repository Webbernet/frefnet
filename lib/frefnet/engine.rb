module Frefnet
  class Engine < ::Rails::Engine
    isolate_namespace Frefnet
  end

  def self.setup(&block)
    @config ||= Frefnet::Engine::Configuration.new
    yield @config if block
    @config
  end

  def self.config
    Rails.application.config
  end
end
