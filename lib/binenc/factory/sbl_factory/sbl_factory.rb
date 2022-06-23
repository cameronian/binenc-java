
require_relative 'sbl_dsl'

module Binenc
  module Java

    # simple binary layout factory
    class SBLFactory
      include SBLDSL
      include DataConversion

      def define(&block)
        instance_eval(&block) 
        self
      end

      def encoded
        res = []
        structure.each do |st|
          res << self.send("#{to_instance_method_name(st)}").encoded(false)
        end

        ASN1Sequence.new(res).encoded
      end

      def from_bin(bin)
       
        seq = ASN1Object.decode(bin).value

        if seq.length > structure.length
          logger.warn "Given binary has more field (#{seq.length}) than the defined specification (#{structure.length}). Different version of structure?"
        elsif structure.length > seq.length
          logger.warn "Defined specification has more field (#{structure.length}) than given binary (#{seq.length}). Different version of structure?"
        end

        structure.each_index do |i|
          name = structure[i]
          val = seq[i]
          create_instance_method(name, val)
        end

        self

      end

      def value_from_bin_struct(bin, *fieldNo)

        seq = ASN1Object.decode(bin).value

        ret = []
        fieldNo.each do |fn|
          raise BinencEngineException, "Given field no '#{fn}' to extract is larger than found fields (#{seq.length})" if fn > seq.length

          v = seq[fn]
          if v.is_a?(::Java::OrgBouncycastleAsn1::ASN1Object)
            case v
            when ::Java::OrgBouncycastleAsn1::DERBitString
              #vv = String.from_java_bytes(v.bytes)
              vv = to_java_bytes(v.bytes)
            when ::Java::OrgBouncycastleAsn1::DERUTF8String
              vv = v.to_s
            when ::Java::OrgBouncycastleAsn1::ASN1Integer
              vv = v.value
            #when ::Java::OrgBouncycastleAsn1::DERSequence, ::Java::OrgBouncycastleAsn1::DLSequence
            #  to_value(v.to_a)
            when ::Java::OrgBouncycastleAsn1::ASN1GeneralizedTime
              d = v.date
              vv = Time.at(d.time/1000)
            when ::Java::OrgBouncycastleAsn1::ASN1ObjectIdentifier
              vv = v.id
            else
              raise BinencEngineException, "Unhandled ASN1 object '#{obj.class}'"
            end

            #begin
            #  vv = ASN1Object.decode(v).value
            #rescue OpenSSL::ASN1::ASN1Error
            #  vv = v
            #end
          else
            vv = v
          end

          ret << vv

        end

        ret
      end

      private
      def logger
        if @logger.nil?
          @logger = TeLogger::Tlogger.new
          @logger.tag = :sbl_fact
        end
        @logger
      end

    end

  end
end
