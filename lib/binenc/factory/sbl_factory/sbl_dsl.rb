
require_relative '../../asn1_engine/asn1_engine'

module Binenc
  module Java
   
    # Simple Binary Layout Domain Specific Language (DSL)
    module SBLDSL
      include TR::CondUtils

      def bin(*args)
        name = args.first
        val = args[1]

        raise BinencEngineException, "Name '#{name}' already defined" if keyRegister.keys.include?(name)

        # register name with field type
        keyRegister[name] = :bin
        # create instance method dynamically with given name
        create_instance_method(name, val)
        # keep the name in sequence as in the layout
        structure << name
      end

      def int(*args)
        name = args.first
        val = args[1]

        raise BinencEngineException, "Name '#{name}' already defined" if keyRegister.keys.include?(name)

        # register name with field type
        keyRegister[name] = :int
        # create instance method dynamically with given name
        create_instance_method(name, val)
        # keep the name in sequence as in the layout
        structure << name
      end

      def oid(*args)
        name = args.first
        val = args[1]

        raise BinencEngineException, "Name '#{name}' already defined" if keyRegister.keys.include?(name)

        # register name with field type
        keyRegister[name] = :bin
        # create instance method dynamically with given name
        create_instance_method(name, val)
        # keep the name in sequence as in the layout
        structure << name
       
      end

      def str(*args)
        name = args.first
        val = args[1]

        raise BinencEngineException, "Name '#{name}' already defined" if keyRegister.keys.include?(name)

        # register name with field type
        keyRegister[name] = :str
        # create instance method dynamically with given name
        create_instance_method(name, val)
        # keep the name in sequence as in the layout
        structure << name
      end

      def date(*args)
        name = args.first
        val = args[1]

        raise BinencEngineException, "Name '#{name}' already defined" if keyRegister.keys.include?(name)

        # register name with field type
        keyRegister[name] = :time
        # create instance method dynamically with given name
        create_instance_method(name, val)
        # keep the name in sequence as in the layout
        structure << name
      end
      alias_method :time, :date

      def seq(*args)
        name = args.first
        val = args[1]

        raise BinencEngineException, "Name '#{name}' already defined" if keyRegister.keys.include?(name)

        # register name with field type
        keyRegister[name] = :seq
        # create instance method dynamically with given name
        create_instance_method(name, val)
        # keep the name in sequence as in the layout
        structure << name
      end

      private
      def keyRegister
        if @keyReg.nil?
          @keyReg = {  }
        end
        @keyReg
      end

      def structure
        if @struct.nil?
          @struct = []
        end
        @struct
      end

      def create_instance_method(name, value = nil)

        raise BinencEngineException, "Name #{name} is not defined" if not keyRegister.keys.include?(name)
    
        instance_eval <<-END
        
        def #{name}=(val)
          #{name}_inst.value = val
        end
        def #{name}
          #{name}_inst.value
        end


        def #{to_instance_method_name(name)}
          if @#{to_instance_method_name(name)}.nil?
            @#{to_instance_method_name(name)} = #{type_to_asn1_object(keyRegister[name])}
          end
          
          @#{to_instance_method_name(name)}
        end

        END

        if not_empty?(value)
          self.send("#{name}=", value)
        end

      end

      def to_instance_method_name(name)
        "#{name}_inst"
      end

      def type_to_asn1_object(type)
        case type
        when :bin
          "ASN1Binary.new"
        when :oid
          "ASN1OID.new"
        when :int
          "ASN1Integer.new"
        when :str
          "ASN1String.new"
        when :seq
          "ASN1Sequence.new"
        when :time
          "ASN1DateTime.new"
        else
          raise BinencEngineException, "Unknown type to ASN1 object #{type}"
        end
      end


    end

  end
end
