

RSpec.describe "Load Java provider" do

  it 'load Java provider into the env' do
    
    require 'binenc/java'

    eng = Binenc::EngineFactory.instance
    expect(eng.nil?).to be false

  end

end
