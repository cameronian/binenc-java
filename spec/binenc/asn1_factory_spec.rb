

RSpec.describe "Define binary structure and helpers to manage the structure" do

  it 'define binary structure' do

    require 'binenc/java'

    af = Binenc::EngineFactory.instance(:bin_struct)
    expect(af.nil?).to be false

    af.define do

      oid :oid, "2.8.9.8"
      int :version, 0x0100
      str :name
      bin :first
      seq :seq
      date :valid

    end


    expect(af.oid == "2.8.9.8").to be true
    expect(af.version == 0x0100).to be true
    
    af.name = "Flat file"
    af.first = SecureRandom.random_bytes(1024)

    af.valid = Time.now

    af.seq << "asdf"

    res = af.encoded
    expect(res.nil?).to be false

    afr = Binenc::EngineFactory.instance(:bin_struct)
    afr.define do

      oid :oid
      int :version
      str :name
      bin :first
      seq :seq
      date :valid

    end

    st = afr.from_bin(res)
    expect(st.oid == af.oid).to be true
    expect(st.first == af.first).to be true
    expect(st.version == af.version).to be true
    expect(st.name == af.name).to be true 
    expect(st.seq == af.seq).to be true
    expect(st.valid.to_i == af.valid.to_i).to be true

    sts = afr.value_from_bin_struct(res, 0, 1)
    p sts

    afe = Binenc::EngineFactory.instance(:bin_struct)
    afe.define do
      oid :oid
      int :version
      str :name
      bin :first
    end

    ste = afe.from_bin(res)
    
  end

end
