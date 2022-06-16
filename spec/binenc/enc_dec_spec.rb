

RSpec.describe "binary encode and decode" do

  it 'encodes and decodes binary fields' do

    require 'binenc/java'
    
    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

    value = SecureRandom.random_bytes(16)
    bo = eng.object(:bin, value)
    expect(bo.nil?).to be false

    bin = bo.encoded
    expect(bin.nil?).to be false

    obj = eng.from_bin(bin)
    expect(obj.nil?).to be false
    expect(obj.is_a?(Binenc::BinaryObject)).to be true
    
    expect(obj.is_equal?(value)).to be true
    expect(obj.is_equal?(SecureRandom.random_bytes(16))).to be false


  end

  it 'encodes and decodes string fields' do

    require 'binenc/java'
    
    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

    value = "This is my string"
    bo = eng.object(:str, value)
    expect(bo.nil?).to be false

    bin = bo.encoded
    expect(bin.nil?).to be false

    obj = eng.from_bin(bin)
    expect(obj.nil?).to be false
    expect(obj.is_a?(Binenc::BinaryObject)).to be true
    
    expect(obj.is_equal?(value)).to be true
    expect(obj.is_equal?("random string")).to be false


  end

  it 'encodes and decodes unicode string fields' do

    require 'binenc/java'
    
    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

    value = "什么事情那样麻烦？"
    bo = eng.object(:str, value)
    expect(bo.nil?).to be false

    bin = bo.encoded
    expect(bin.nil?).to be false

    obj = eng.from_bin(bin)
    expect(obj.nil?).to be false
    expect(obj.is_a?(Binenc::BinaryObject)).to be true
    
    expect(obj.is_equal?(value)).to be true
    expect(obj.is_equal?("天气凉爽")).to be false


  end

  it 'encodes and decodes integer fields' do

    require 'binenc/java'
    
    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

    value = 0x1212
    bo = eng.object(:int, value)
    expect(bo.nil?).to be false

    bin = bo.encoded
    expect(bin.nil?).to be false

    obj = eng.from_bin(bin)
    expect(obj.nil?).to be false
    expect(obj.is_a?(Binenc::BinaryObject)).to be true
    
    expect(obj.is_equal?(value)).to be true
    expect(obj.is_equal?(0x1111)).to be false


  end

  it 'encodes and decodes big integer fields' do

    require 'binenc/java'
    
    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

    value = rand(2**4096..2**8192) 
    expect(value.is_a?(Bignum)).to be true
    bo = eng.object(:int, value)
    expect(bo.nil?).to be false

    bin = bo.encoded
    expect(bin.nil?).to be false

    obj = eng.from_bin(bin)
    expect(obj.nil?).to be false
    expect(obj.is_a?(Binenc::BinaryObject)).to be true
    
    expect(obj.is_equal?(value)).to be true
    expect(obj.is_equal?(0x1111)).to be false

  end

  it 'encodes and decodes datetime fields' do

    require 'binenc/java'
    
    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

    value = Time.now
    bo = eng.object(:date, value)
    expect(bo.nil?).to be false

    bin = bo.encoded
    expect(bin.nil?).to be false

    obj = eng.from_bin(bin)
    expect(obj.nil?).to be false
    expect(obj.is_a?(Binenc::BinaryObject)).to be true
    
    expect(obj.is_equal?(value)).to be true
    expect(obj.is_equal?(Time.new(value.year, value.month, value.day))).to be false

  end

  it 'encodes and decodes OID fields' do

    require 'binenc/java'
    
    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

    value = "2.8.8.18"
    bo = eng.object(:oid, value)
    expect(bo.nil?).to be false

    bin = bo.encoded
    expect(bin.nil?).to be false

    obj = eng.from_bin(bin)
    expect(obj.nil?).to be false
    expect(obj.is_a?(Binenc::BinaryObject)).to be true
    
    expect(obj.is_equal?(value)).to be true
    expect(obj.is_equal?("2.8.9")).to be false

  end

  it 'encodes and decodes sequence fields' do

    require 'binenc/java'
    
    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

    value = [12312, "testing", 0x01001, SecureRandom.random_bytes(16)]
    bo = eng.object(:seq, value)
    expect(bo.nil?).to be false

    bin = bo.encoded
    expect(bin.nil?).to be false

    obj = eng.from_bin(bin)
    expect(obj.nil?).to be false
    expect(obj.is_a?(Binenc::BinaryObject)).to be true
    
    expect(obj.is_equal?(value)).to be true
    vv = []
    vv << value[1]
    vv << value[0]
    vv << value[3]
    vv << value[2]
    expect(obj.is_equal?(vv)).to be true
    
    vve = [12312, "testing", SecureRandom.random_bytes(16), 0x01001]
    expect(obj.is_equal?(vve)).to be false

  end


end
