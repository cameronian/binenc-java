# frozen_string_literal: true

require 'teLogger'
require 'toolrack'

Dir.glob(File.join(File.dirname(__FILE__),"..","..","jars","*.jar")).each do |f|
  require f
  #puts "Loaded #{f}"
end

require_relative "java/version"

require_relative 'provider'

module Binenc
  module Java
    class Error < StandardError; end
    # Your code goes here...
  end
end


# register the provider
require 'binenc'
Binenc::Provider.instance.register(Binenc::Java::Provider)


