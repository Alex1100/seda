require "spec_helper"

describe Seda do
  it "has a version number" do
    expect(Seda::VERSION).not_to be nil
  end


  it "tests the identity method" do
    test_result = Seda.identity('hi')

    expect(test_result.class).to be(String)
    expect(test_result).to eq('hi')
  end


  it "tests the first method" do
    test_result_1 = Seda.first([1, 2, 3, 4], 5)
    test_result_2 = Seda.first([1, 2, 3, 4], 2)

    expect(test_result_1).to eq([1, 2, 3, 4])
    expect(test_result_2).to eq([1, 2])
  end
end
