module Frefnet
  class Engine < ::Rails::Engine
    isolate_namespace Frefnet

    initializer "s3 presigner" do
      PRESIGN_CLIENT = Aws::S3::Presigner.new
    end
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
