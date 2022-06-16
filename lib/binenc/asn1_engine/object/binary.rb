

module Binenc
  module Java

    class ASN1Binary
      include ASN1Object

      def encoded(binary = true)
        obj = org.bouncycastle.asn1.DERBitString.new(to_java_bytes(@value))

        if binary
          obj.encoded
        else
          obj
        end
      end

      def is_equal?(val)
        @value == to_java_bytes(val)
      end

    end
  end
end
