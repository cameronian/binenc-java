
require_relative 'sbl_factory/sbl_factory'

module Binenc
  module Java
    module BinStructFactory
     
      def self.instance(*args, &block)
        SBLFactory.new        
      end

    end    
  end
end
