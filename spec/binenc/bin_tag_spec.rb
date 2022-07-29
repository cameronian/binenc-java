


RSpec.describe "Java specific hash key integer issue" do

  it 'matched with hash key that is integer' do
    
    hash = { key: 0x01 }

    expect(hash[:key] == 0x01).to be true

    rhash = hash.invert
    expect(rhash[0x01] == :key).to be true
    expect(rhash[1] == :key).to be true

    ki = ::Java::JavaLang::Integer.new(1)
    expect(rhash[ki.to_i] == :key).to be true

  end

end
