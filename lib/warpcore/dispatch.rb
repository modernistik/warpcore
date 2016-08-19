require 'sucker_punch'
require 'active_support'
require 'active_support/core_ext'

module WarpCore

  class SerialDispatchQueue
    include SuckerPunch::Job
    workers 1 # serial queue

    def perform(block = nil)
      block.call() if block.respond_to?(:call)
    end
  end

  class ParallelDispatchQueue
    include SuckerPunch::Job

    def perform(block = nil)
      block.call() if block.respond_to?(:call)
    end
  end

  def self.async(type = :serial)
    raise "You need to pass a block to async." unless block_given?
    if type == :parallel
      WarpCore::ParallelDispatchQueue.perform_async Proc.new
    else
      WarpCore::SerialDispatchQueue.perform_async Proc.new
    end
  end

  def self.delay_by(seconds, type = :serial)
    raise "You need to pass a block to delay_by." unless block_given?
    if type == :parallel
      WarpCore::ParallelDispatchQueue.perform_in seconds.to_i, Proc.new
    else
      WarpCore::SerialDispatchQueue.perform_in seconds.to_i, Proc.new
    end
  end

end
