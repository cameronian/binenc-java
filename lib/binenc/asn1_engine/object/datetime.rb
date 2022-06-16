

module Binenc
  module Java
    
    class ASN1DateTime
      include ASN1Object
      
      def encoded(binary = true)
        raise BinencEngineException, "Given value is not a Time object. #{@value.class}" if not (@value.is_a?(Time) or @value.is_a?(java.util.Date))
        obj = org.bouncycastle.asn1.DERGeneralizedTime.new(@value)
        if binary
          obj.encoded
        else
          obj
        end
      end

      def is_equal?(val)

        case val
        when Integer
          @value.time.to_i == val
        when Time
          @value.time.to_i == val.to_i*1000
        else
          @value == val
        end
        
      end

    end

  end
end
