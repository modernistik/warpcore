require 'open-uri'
require 'active_support'
require 'active_support/core_ext'

module WarpCore
  # Class provides a helper method to load
  class Env
    # Applies a remote JSON hash containing the ENV keys and values from a remote
    # URL. Values from the JSON hash are only applied to the current ENV hash ONLY if
    # it does not already have a value. Therefore local ENV values will take precedence
    # over remote ones. By default, it uses the url in value in ENV['ENV_URL'].
    # @param url [String] the remote url that responds with the JSON body.
    # @return [Boolean] true if the JSON hash was found and applied successfully.
    def self.load_url!(url = nil)
      url ||= ENV["ENV_URL"]
      if url.present?
        begin
          remote_config = JSON.load open( url )
          remote_config.each do |key,value|
            k = key.upcase
            ENV[k] ||= value.to_s
          end
          return true
        rescue => e
          warn "[WarpCore::Config] Error loading config: #{url} (#{e})"
        end
      end
      false
    end

  end
end
