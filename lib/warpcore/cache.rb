require 'moneta'
require 'active_support'
require 'active_support/core_ext'

module WarpCore
  # cache helper
  def self.cache(key,opts = {})
    if block_given?
      WarpCore::Cache.get( key, opts, Proc.new )
    else
      WarpCore::Cache.get( key, opts )
    end
  end

  class Cache
    class << self
      attr_accessor :store

      def setup(moneta, opts = {})
        @store = moneta
      end

      def get(key, opts = {}, block = nil)
        block = Proc.new if block_given? && block.nil?
        valid = block.respond_to?(:call)
        if @store.nil?
          return valid ? block.call(key) : nil
        end
        return @store[key] unless block.respond_to?(:call)
        opts[:expires] = opts[:expires].to_i if opts[:expires].present?
        @store.fetch(key, opts) do |key|
          val = block.call(key)
          self.set(key, val, opts)
        end
      rescue Exception => e
        warn "[WarpCore::Cache] Fetch Error => #{e}"
        block.respond_to?(:call) ? block.call(key) : nil
      end

      def set(key,value, opts = {})
        @store&.store(key, value, opts) || value
      rescue Exception => e
        warn "[WarpCore::Cache] Store Error => #{e}"
        value
      end
    end
  end
end
