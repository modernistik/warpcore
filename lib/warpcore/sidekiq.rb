require 'sidekiq'
require 'redis'
require 'active_support'
require 'active_support/core_ext'

module WarpCore

  # @return [RedisPoolInstance] a usable redis instance shared by Sidekiq.
  def self.redis
    WarpCore::RedisPoolInstance.new
  end

  # Asynchronously dispatch a Sidekiq worker with the provided arguments. This
  # is equivalent to calling the worker directly with `perform_async`.
  # @example
  #   WarpCore.dispatch 'Workers::MyWorker', argument1, argument2.....
  # @param worker_name [String] the full class path of the worker (ex. `Workers::MyWorker`)
  # @param args [Array] the arguments to pass to the worker.
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

  # Asynchronously dispatch a Sidekiq worker at a later time with the provided
  # arguments. This is equivalent to calling the worker directly with `perform_in`.
  # @example
  #   WarpCore.dispatch_in 'Workers::MyWorker', 10.seconds, argument1, argument2.....
  # @param worker_name (see WarpCore.dispatch)
  # @param args [Array] the arguments to pass to the worker. The first argument
  #  should be the amount of time to wait before dispatching the worker.
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

  # Synchronously dispatch a Sidekiq worker with the provided
  # arguments. This is equivalent to instantiating the worker instance directly
  # and calling `perform` on it.
  # @example
  #   WarpCore.dispatch_sync 'Workers::MyWorker', argument1, argument2.....
  # @param worker_name (see WarpCore.dispatch)
  # @param args [Array] the arguments to pass to the worker.
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

  # This class simply delegates every method call to the Sidekiq redis connection.
  # Use RedisPoolInstance.new to get a shared redis connection.
  class RedisPoolInstance
    # @!visibility private
    def method_missing(meth, *args, &block)
      Sidekiq.redis do |connection|
        connection.send(meth, *args, &block)
      end
    end
    # @!visibility private
    def respond_to_missing?(meth)
      Sidekiq.redis do |connection|
        connection.respond_to?(meth)
      end
    end
  end


end
