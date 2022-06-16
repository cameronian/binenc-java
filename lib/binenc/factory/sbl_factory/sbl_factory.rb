
require_relative 'sbl_dsl'

module Binenc
  module Java

    # simple binary layout factory
    class SBLFactory
      include SBLDSL

      def define(&block)
        instance_eval(&block) 
      end

      def load_definition(path)
        raise BinencEngineException, "Given spec to load '#{path}' does not exist" if not File.exist?(path)
        File.open(path,"r") do |f|
          @cont = f.read
        end

        instance_eval(@cont)
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
