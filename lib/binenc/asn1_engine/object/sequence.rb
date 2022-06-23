

module Binenc
  module Java
    
    class ASN1Sequence
      include ASN1Object 

      def initialize(*args, &block)
        super
        @value = to_value(@value) 
      end

      def encoded(binary = true)
        @value = [@value] if not @value.is_a?(Array)
        value = to_encoded(@value)
        obj = org.bouncycastle.asn1.DERSequence.new(value)

        if binary
          obj.encoded
        else
          obj
        end
      end

      def is_equal?(val)

        if @value.length == val.length
          res = true
          @value.each do |e|
            if not val.include?(e)
              res = false
              break
            end
          end
          res
        else
          false
        end
      end

      private
      def is_binary_string?(str)
        not str.ascii_only?
      end

      def to_encoded(val)

        if not val.nil?
          val = [val] if not val.is_a?(Array)
          
          v = val.map do |e|

            case e
            when Integer
              ASN1Integer.new(e).encoded(false)
            when String
              if is_binary_string?(e)
                ASN1Binary.new(e).encoded(false)
              else
                ASN1String.new(e).encoded(false)
              end
            when Array
              ASN1Sequence.new(e).encoded(false)
            when Time, java.util.Date
              ASN1DateTime.new(e).encoded(false)

            when ::Java::OrgBouncycastleAsn1::DERBitString
              ASN1Binary.new(e.bytes).encoded(false)
            when ::Java::OrgBouncycastleAsn1::DERUTF8String
              ASN1String.new(e.to_s).encoded(false)
            when ::Java::OrgBouncycastleAsn1::ASN1Integer
              ASN1Integer.new(e.value).encoded(false)
            when ::Java::OrgBouncycastleAsn1::DERSequence, ::Java::OrgBouncycastleAsn1::DLSequence
              ASN1Sequence.new(e.to_a).encoded(false)
            when ::Java::OrgBouncycastleAsn1::ASN1GeneralizedTime
              ASN1DateTime.new(e.date).encoded(false)
            when ::Java::OrgBouncycastleAsn1::ASN1ObjectIdentifier
              ASN1OID.new(e.id).encoded(false)
            else
              logger.debug "Oopss #{e} / #{e.class}"
              nil
            end

          end # map

          v.delete_if { |e| e.nil? }

          vec = org.bouncycastle.asn1.ASN1EncodableVector.new
          v.each do |ve|
            vec.add(ve)
          end
          vec

        else
          org.bouncycastle.asn1.ASN1EncodableVector.new
        end


      end

      def to_value(arr)
       
        if not arr.nil? 
          arr = [arr] if not arr.is_a?(Array)

          arr.map do |e|
            case e
            when ::Java::byte[]
              ASN1Object.decode(e).value
            when ::Java::OrgBouncycastleAsn1::ASN1Object
              case e
              when ::Java::OrgBouncycastleAsn1::DERBitString
                String.from_java_bytes(e.bytes)
              when ::Java::OrgBouncycastleAsn1::DERUTF8String
                e.to_s
              when ::Java::OrgBouncycastleAsn1::ASN1Integer
                e.value
              when ::Java::OrgBouncycastleAsn1::DERSequence, ::Java::OrgBouncycastleAsn1::DLSequence
                to_value(e.to_a)
              when ::Java::OrgBouncycastleAsn1::ASN1GeneralizedTime
                d = e.date
                Time.at(d.time/1000)
              when ::Java::OrgBouncycastleAsn1::ASN1ObjectIdentifier
                e.id
              else
                raise BinencEngineException, "Unhandled ASN1 object '#{obj.class}'"
              end
            else
              e
            end

          end # map

        else
          []
        end

      end

      def logger
        if @logger.nil?
          @logger = TeLogger::Tlogger.new
          @logger.tag = :asn1_seq
        end
        @logger
      end

    end

  end
end
