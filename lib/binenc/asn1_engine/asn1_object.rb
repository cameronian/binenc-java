
require 'binenc'

require_relative '../data_conversion'

module Binenc
  module Java
    module ASN1Object
      include Binenc::BinaryObject
      include TR::CondUtils
      include DataConversion
     
      attr_accessor :value

      def initialize(*args, &block)
        @value = args.first
      end

      def is_equal?(val)
        @value == val
      end

      def self.decode(bin)
        if not_empty?(bin)

          begin
            ais = ::Java::OrgBouncycastleAsn1::ASN1InputStream.new(to_java_bytes(bin))
            obj = ais.readObject

            case obj
            when ::Java::OrgBouncycastleAsn1::DERBitString
              ASN1Binary.new(obj.bytes)
            when ::Java::OrgBouncycastleAsn1::DERUTF8String
              ASN1String.new(obj.to_s)
            when ::Java::OrgBouncycastleAsn1::ASN1Integer
              ASN1Integer.new(obj.value)
            when ::Java::OrgBouncycastleAsn1::DERSequence, ::Java::OrgBouncycastleAsn1::DLSequence
              ASN1Sequence.new(obj.to_a)
            when ::Java::OrgBouncycastleAsn1::ASN1GeneralizedTime
              ASN1DateTime.new(obj.date)
            when ::Java::OrgBouncycastleAsn1::ASN1ObjectIdentifier
              ASN1OID.new(obj.id)
            else
              raise BinencEngineException, "Unhandled ASN1 object '#{obj.class}'"
            end
          rescue ::Java::JavaIo::IOException => ex
            raise BinencDecodingError, ex
          end

        else
          raise BinencEngineException, "Cannot decode empty binary #{bin}"
        end
      end

      private
      def self.logger
        if @logger.nil?
          @logger = TeLogger::Tlogger.new
          @logger.tag = :java_asn1Obj
        end
        @logger
      end

      def logger
        self.class.logger
      end


    end
  end
end


Dir.glob(File.join(File.dirname(__FILE__),"object","*.rb")) do |f|
  require_relative f
end


