
require_relative 'asn1_object'

module Binenc
  module Java
    class ASN1Engine

      def object(type, *args)
        case type
        when :bin, :binary
          ASN1Binary.new(*args)
        when :str, :string
          ASN1String.new(*args)
        when :int, :integer, :number, :num
          ASN1Integer.new(*args)
        when :seq, :sequence
          ASN1Sequence.new(*args)
        when :date, :datetime, :time
          ASN1DateTime.new(*args)
        when :oid
          ASN1OID.new(*args)
        else
          raise BinencEngineException, "Unknown ASN1 object '#{type}'"
        end
      end

      def from_bin(bin)
        ASN1Object.decode(bin)
      end

    end
  end
end
