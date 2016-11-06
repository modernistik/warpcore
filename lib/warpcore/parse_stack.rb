require 'parse/stack'
require_relative 'dispatch'

module Parse
  class Object

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
