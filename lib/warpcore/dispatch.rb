require 'sucker_punch'
require 'active_support'
require 'active_support/core_ext'

module WarpCore
  # A class to support running blocks in a serial queue on a background thread.
  class SerialDispatchQueue
    include SuckerPunch::Job
    workers 1 # serial queue
    # @!visibility private
    def perform(block = nil)
      block.call() if block.respond_to?(:call)
    end
  end

  # A class to support running blocks in concurrent queue on a background thread.
  class ParallelDispatchQueue
    include SuckerPunch::Job
    # @!visibility private
    def perform(block = nil)
      block.call() if block.respond_to?(:call)
    end
  end

  # Helper method to run a block on a background thread.
  # @param type [Symbol] the queue to use when dispatching the block.
  #   * :serial - use the {SerialDispatchQueue}
  #   * :parallel - use the {ParallelDispatchQueue}
  def self.async(type = :serial)
    raise "You need to pass a block to async." unless block_given?
    if type == :parallel
      WarpCore::ParallelDispatchQueue.perform_async Proc.new
    else
      WarpCore::SerialDispatchQueue.perform_async Proc.new
    end
  end

  # Helper method to run a block on a background thread.
  # @param type (see WarpCore.async)
  #   * :serial - use the {SerialDispatchQueue}
  #   * :parallel - use the {ParallelDispatchQueue}
  def self.delay_by(seconds, type = :serial)
    raise "You need to pass a block to delay_by." unless block_given?
    if type == :parallel
      WarpCore::ParallelDispatchQueue.perform_in seconds.to_i, Proc.new
    else
      WarpCore::SerialDispatchQueue.perform_in seconds.to_i, Proc.new
    end
  end

end
