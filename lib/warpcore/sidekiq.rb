require 'sidekiq'
require 'redis'
require 'active_support'
require 'active_support/core_ext'

module WarpCore

  def self.redis
    WarpCore::RedisPoolInstance.new
  end

  def self.dispatch(worker_name, *args)
    klass = worker_name.constantize
    if klass.respond_to?(:perform_async)
      puts "=> [Dispatch:Async] #{worker_name}"
      return klass.perform_async(*args)
    else
      warn "Dispatched #{worker_name} not a valid Sidekiq worker."
      nil
    end
  rescue NameError => e
    puts "Worker [#{worker_name}] not defined."
    nil
  end

  def self.dispatch_in(worker_name, *args)
    klass = worker_name.constantize
    if klass.respond_to?(:perform_async)
      puts "=> [Dispatch:Delay] #{worker_name}"
      return klass.perform_in(*args)
    else
      warn "Dispatched #{worker_name} not a valid Sidekiq worker."
      nil
    end
  rescue NameError => e
    puts "Worker [#{worker_name}] not defined."
    nil
  end

  def self.dispatch_sync(worker_name, *args)
    klass = worker_name.constantize
    object = klass.new
    if object.respond_to?(:perform)
      puts "=> [Dispatch:Sync] #{worker_name}"
      return object.perform(*args)
    else
      warn "Perform #{worker_name} not a valid Sidekiq worker."
      nil
    end
  rescue NameError => e
    puts "Worker [#{worker_name}] not defined."
    nil
  end

  # Because +Sidekiq.redis+ requires passing a block,
  # we can't pass it straight to +Redis::Semaphore+.
  # This class simply delegates every method call to
  # the Sidekiq connection.
  # use RedisPoolInstance.new to get a shared redis connection
  class RedisPoolInstance

    def method_missing(meth, *args, &block)
      Sidekiq.redis do |connection|
        connection.send(meth, *args, &block)
      end
    end

    def respond_to_missing?(meth)
      Sidekiq.redis do |connection|
        connection.respond_to?(meth)
      end
    end
  end


end
