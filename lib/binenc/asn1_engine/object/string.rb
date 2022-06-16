

module Binenc
  module Java
    
    class ASN1String
      include ASN1Object

      def encoded(binary = true)
        obj = org.bouncycastle.asn1.DERUTF8String.new(@value.to_s)
        if binary
          obj.encoded
        else
          obj
        end
      end

      def is_equal?(val)
        @value.bytes == val.bytes
      end

    end

  end
end
