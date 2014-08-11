module Sampl
  module Util
    
    # copied from HTTParty that borrowed it from Rails 3.2 ActiveSupport ;-)
    def self.hash_deep_dup(hash)
      duplicate = hash.dup

      duplicate.each_pair do |key, value|
        duplicate[key] = if value.is_a?(Hash)
          hash_deep_dup(value)
        elsif value.is_a?(Proc)
          duplicate[key] = value.dup
        else
          value
        end
      end

      duplicate
    end
    
  end
end