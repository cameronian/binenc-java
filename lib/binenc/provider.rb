
require_relative 'asn1_engine/asn1_engine'

require_relative 'asn1_engine/asn1_object'

require_relative 'factory/bin_struct_factory'

module Binenc
  module Java
    class Provider
      include TR::CondUtils

      def self.provider_name
        "Java"
      end

      def self.engine_instance(*args, &block)
        eng = args.first


        if is_empty?(eng)
          ASN1Engine.new(*args[1..-1], &block)
        else

          case eng.to_s.downcase.to_sym
          when :asn1, :asn1_eng
            ASN1Engine.new(*args[1..-1], &block)
          when :bin_struct, :binstruct
            BinStructFactory.instance(*args, &block)
          else
            raise BinencEngineException, "Engine #{eng} is not supported"
          end
        end

      end

    end
  end
end


