

module Binenc
  module Java
    
    class ASN1Integer
      include ASN1Object

      def encoded(binary = true)
        obj = org.bouncycastle.asn1.DERInteger.new(@value)
        if binary
          obj.encoded
        else
          obj
        end
      end
    end

  end
end
