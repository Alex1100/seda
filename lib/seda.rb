require "seda/version"

module Seda

  def self.identity(value)
    value
  end

  def self.first(arr, n_first_elements)
    n_first_elements == nil ? arr[0] : arr.slice(0, n_first_elements)
  end

  def self.index_of(arr, target)
    if(arr == nil)
      return arr
    end

    result = -1

    arr.each_with_index do |element, i|
      if(element == target && result == -1)
        result = i
      end
    end

    result
  end

  def self.contains(collection, target)
    collection.each do |element|
      if element == target
        return true
      end
    end
    false
  end


  def self.defaults(*obj)
    final_object = (eval(local_variables[0].to_s))[0]
    iterables = (eval(local_variables[0].to_s))[1..-1]

    if final_object != nil && iterables.class == Array
      iterables.each do |element|
        if element.class == Hash
          p element.class
          for k in element
            if final_object[k[0].to_s] == nil
              final_object[k[0].to_s] = k[1]
            end
          end
        elsif element.class == Array
          element.each do |item|
            if final_object[item.to_s] == nil
              final_object[item.to_s] = item
            end
          end
        else
          if final_object[element.to_s] == nil
            final_object[element.to_s] = element
          end
        end
      end
    else
      raise ArgumentError.new('Must pass in the destination Hash as first argument, and additional argument objects to extend values from')
    end

    return final_object
  end


  def self.extend(*obj)
    final_object = (eval(local_variables[0].to_s))[0]
    iterables = (eval(local_variables[0].to_s))[1..-1]

    if final_object != nil && iterables.class == Array
      iterables.each do |element|
        if element.class == Hash
          p element.class
          for k in element
            final_object[k[0].to_s] = k[1]
          end
        elsif element.class == Array
          element.each do |item|
            final_object[item.to_s] = item
          end
        else
          final_object[element.to_s] = element
        end
      end
    else
      raise ArgumentError.new('Must pass in the destination Hash as first argument, and additional argument objects to extend values from')
    end
  end

  def self.







end
