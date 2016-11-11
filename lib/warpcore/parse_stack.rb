require 'parse/stack'
require_relative 'dispatch'

module Parse
  class Object
    # Adds support for saving a Parse::Object instance in the background.
    # If an exception is thrown, it is handled silently.
    # @yield A block to call after the save has completed successfully
    def save_eventually
      block = block_given? ? Proc.new : nil
      WarpCore.async do
        begin
          self.save
          block.call(self) if block
        rescue => e
          puts "[SaveEventually] Failed for object #{id}: #{e}"
        end
      end
    end

    # Same as {save_eventually}, but calls `save` on an object in the if it is
    # new, otherwise it calls `update!`.
    # If an exception is thrown, it is handled silently.
    # @yield (see Parse::Object#save_eventually)
    # @see #save_eventually
    def save_eventually!
        WarpCore.async do
          begin
            self.new? ? self.save : self.update!
          rescue => e
            puts "[SaveEventually!] Failed for object #{id}: #{e}"
          end
        end
    end

  end
end
