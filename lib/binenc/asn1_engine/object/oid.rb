

module Binenc
  module Java
   
    class ASN1OID
      include ASN1Object

      def encoded
        org.bouncycastle.asn1.ASN1ObjectIdentifier.new(@value).encoded
      end

    end

  end
end
