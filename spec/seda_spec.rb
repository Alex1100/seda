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

  it "tests the index_of method" do
    test_result_1 = Seda.index_of([1, 2, 3, 4], 2)
    test_result_2 = Seda.index_of([1, 2, 3, 4], 5)

    expect(test_result_1).to be(1)
    expect(test_result_2).to be(-1)
  end

  it "tests the contains method" do
    test_result_1 = Seda.contains([1, 2, 3, 4, 5], 5)
    test_result_2 = Seda.contains([1, 2, 3, 4, 5], 10)

    expect(test_result_1).to eq true
    expect(test_result_2).to eq false
  end

  it "tests the defaults method" do
    test_result_1 = Seda.defaults({a: 1}, {b: 2}, {b: 'two'})
    test_result_2 = Seda.defaults({a: 1}, {b: 2}, {c: 'two'})

    expect(test_result_1).to eq({a: 1, b: 2})
    expect(test_result_2).to eq({a: 1, b: 2, c: 'two'})
    expect {Seda.defaults([], {a: 1})}.to raise_error(ArgumentError)
  end

  it "tests the extend method" do
    test_result_1 = Seda.extend({a: 1}, {b: 2}, {b: 'two'})
    test_result_2 = Seda.extend({a: 1}, {b: 2}, {c: 'two'})
    test_result_3 = Seda.extend({a: 1}, {'2' => 'yo'}, {'3': 'hi'})

    expect(test_result_1).to eq({'a' => 1, 'b' => 'two'})
    expect(test_result_2).to eq({'a' => 1, 'b' => 2, 'c' => 'two'})
    expect(test_result_3).to eq({'a' => 1, '2' => 'yo', '3' => 'hi'})
    expect {Seda.extend([], {a: 1})}.to raise_error(ArgumentError)
  end


  it "tests the intersection method" do
    test_result_1 = Seda.intersection([1, 2, 3, 4], [1, 4, 7, 99], [88, 3, 1])

    expect(test_result_1).to eq([1])
  end

  it "tests the last method" do
    test_result_1 = Seda.last([1, 2, 3, 4], 2)
    test_result_2 = Seda.last([1, 2, 3, 4], 1000)

    expect(test_result_1).to eq([3, 4])
    expect(test_result_2).to eq([1, 2, 3, 4])
  end

  it "tests the pluck method" do
    test_result_1 = Seda.pluck([{'a' => 1}, {'a' => 'password'}], 'a')
    test_result_2 = Seda.pluck([{a: 1}, {'a' => 'password'}], 'a')
    test_result_3 = Seda.pluck([{a: 1}, {'a' => 'password'}], :a)

    expect(test_result_1).to eq([1, 'password'])
    expect(test_result_2).to eq([nil, 'password'])
    expect(test_result_3).to eq([1, nil])
  end

  it "tests the shuffe method" do
    test_result = Seda.shuffle(Seda.shuffle([1, 2, 3, 4]))

    expect(test_result).to_not eq([1, 2, 3, 4])
    expect(test_result.size).to eq([1, 2, 3, 4].size)
  end

  it "tests the filter method" do
    def is_it_even(collection, idx)
      collection[idx] % 2 == 0
    end

    test_result_1 = Seda.filter([1, 2, 3, 4], method(:is_it_even))

    expect(test_result_1).to eq([2, 4])
  end

  it "tests the filter method with a Hash" do
    def is_it_even(element)
      element % 2 == 0
    end

    test_result_1 = Seda.filter({'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4}, method(:is_it_even))

    expect(test_result_1).to eq({'b' => 2, 'd' => 4})
  end


  it "tests the reject method with an Array" do
    def is_it_even(collection, idx)
      collection[idx] % 2 == 0
    end

    test_result_1 = Seda.reject([1, 2, 3, 4], method(:is_it_even))

    expect(test_result_1).to eq([1, 3])
  end

  it "tests the reject method with a Hash" do
    def is_it_even(element)
      element % 2 == 0
    end

    test_result_1 = Seda.reject({'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4}, method(:is_it_even))

    expect(test_result_1).to eq({'a' => 1, 'c' => 3})
  end


  it "tests the reduce method and finds the sum of Array elements" do
    def sum_it_up(accumulator, element)
      accumulator + element
    end

    test_result = Seda.reduce([1, 2, 3, 4], method(:sum_it_up))
    expect(test_result).to eq(10)
  end

  it "tests the reduce method and finds the sum of a Hashes values" do
    def sum_it_up(accumulator, element)
      accumulator + element
    end

    test_result = Seda.reduce({'a' => 1, b: 2, c: 3, d: 4}, method(:sum_it_up))
    expect(test_result).to eq(10)
  end

  it "should test the reduce method for immutability" do
    bands = {
     'a' => {name: 'sunset rubdown', country: 'UK', active: false},
     'b' => {name: 'women', country: 'Germany', active: false},
     'c' => {name: 'a silver mt. zion', country: 'Spain', active: true},
     'd' => {name: 'New Death', country: 'Canada', active: false}
    }


    def set_tibet_as_country(band)
      band[:country] = 'Tibet'
    end

    def strip_punctuation_from_name(band)
      band[:name] = band[:name].delete('.')
    end

    def capitalize_names(band)
      band[:name] = band[:name].upcase
    end

    def pipeline_each(accumulator, element, idx)
      if idx == 1
        set_tibet_as_country(accumulator)
        strip_punctuation_from_name(accumulator)
        capitalize_names(accumulator)
        set_tibet_as_country(element)
        strip_punctuation_from_name(element)
        capitalize_names(element)
      else
        set_tibet_as_country(element)
        strip_punctuation_from_name(element)
        capitalize_names(element)
      end
    end

    test_result_1 = Seda.reduce(bands, method(:pipeline_each))
    test_result_1_expected = {"a"=>{:name=>"SUNSET RUBDOWN", :country=>"Tibet", :active=>false}, "b"=>{:name=>"WOMEN", :country=>"Tibet", :active=>false}, "c"=>{:name=>"A SILVER MT ZION", :country=>"Tibet", :active=>true}, "d"=>{:name=>"NEW DEATH", :country=>"Tibet", :active=>false}}

    expect(test_result_1).to eq(test_result_1_expected)
    expect(test_result_1.object_id).to_not eq(bands.object_id)
  end


  it "tests the difference method" do
    test_result_1 = Seda.difference([1, 2, 3, 4], [2, 7], [4, 66, 55])

    expect(test_result_1).to eq([1, 3])
  end


  it "tests the delay method" do
    def sum_it_up(a, b)
      a + b
    end

    expect(Seda.delay(method(:sum_it_up), 200, 5, 5)).to eq(10)
  end


  it "tests the every method" do
    def is_it_even(element)
      element % 2 == 0
    end

    test_result_1 = Seda.every([1, 2, 3, 4], method(:is_it_even))
    test_result_2 = Seda.every([2, 4, 6, 8], method(:is_it_even))

    expect(test_result_1).to be false
    expect(test_result_2).to be true
  end


  it "tests the flatten method" do
    test_result_1 = Seda.flatten([1, 2, 3, [4, [[[], 5, 6, 7]]]])

    expect(test_result_1).to eq([1, 2, 3, 4, 5, 6, 7])
  end


  it "tests the map method" do

  end




end
