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

  def self.intersection(*arrays)
    result = []

    checker = (eval(local_variables[0].to_s))[0]
    iterables = (eval(local_variables[0].to_s))[1..-1]

    checker.each do |item|
      is_shared = false
      iterables.each_with_index do |check|
        check.each do |inner_item|
          if item == inner_item
            is_shared = true
          end
        end
      end

      if is_shared == true
        result << item
      end
    end

    result
  end


  def self.last(arr, n)
    if(n > arr.length)
      arr
    else
      n == nil ? arr[arr.length - 1] : arr.slice(arr.length - n, arr.length)
    end
  end


  def self.pluck(collection, key)
    collection.map{|item| item[key]}
  end

  def self.shuffle(arr)
    cloned_arr = arr.clone
    pos = ''
    temp = []

    cloned_arr.each_with_index do |item, i|
      pos = (Random.new().rand * cloned_arr.length).floor
      temp = cloned_arr[i]
      cloned_arr[i] = cloned_arr[pos]
      cloned_arr[pos] = temp
    end

    cloned_arr
  end

  def self.filter(collection, some_method)
    arr = []

    if collection.class == Array
      collection.each_with_index do |element, idx|
        if some_method.class == String
          if method(some_method.to_sym).call(element, idx)
            arr << element
          end
        elsif some_method.class == Symbol
          if method(some_method).call(element, idx)
            arr << element
          end
        elsif some_method.class == Method
          if some_method.call(element, idx)
            arr << element
          end
        else
          raise ArgumentError.new('The second argument must be a method. You could pass in the actual method, a string of the method name, or a symbol of the method name. Both arguments are needed.')
        end
      end
    elsif collection.class == Hash
      for k in collection
        if some_method.class == String
          if method(some_method.to_sym).call(k[1])
            arr << k[1]
          end
        elsif some_method.class == Symbol
          if method(some_method).call(k[1])
            arr << k[1]
          end
        elsif some_method.class == Method
          if some_method.call(k[1])
            arr << k[1]
          end
        else
          raise ArgumentError.new('The second argument must be a method. You could pass in the actual method, a string of the method name, or a symbol of the method name. Both arguments are needed.')
        end
      end
    else
       raise ArgumentError.new('Must provide an Array, or a Hash as the first Argument.')
    end

    arr
  end


  def self.reject(collection, some_method)
    arr = []

    if collection.class == Array
      collection.each_with_index do |element, idx|
        if some_method.class == String
          if !method(some_method.to_sym).call(element, idx)
            arr << element
          end
        elsif some_method.class == Symbol
          if !method(some_method).call(element, idx)
            arr << element
          end
        elsif some_method.class == Method
          if !some_method.call(element, idx)
            arr << element
          end
        else
          raise ArgumentError.new('The second argument must be a method. You could pass in the actual method, a string of the method name, or a symbol of the method name. Both arguments are needed.')
        end
      end
    elsif collection.class == Hash
      for k in collection
        if some_method.class == String
          if !method(some_method.to_sym).call(k[1])
            arr << k[1]
          end
        elsif some_method.class == Symbol
          if !method(some_method).call(k[1])
            arr << k[1]
          end
        elsif some_method.class == Method
          if !some_method.call(k[1])
            arr << k[1]
          end
        else
          raise ArgumentError.new('The second argument must be a method. You could pass in the actual method, a string of the method name, or a symbol of the method name. Both arguments are needed.')
        end
      end
    else
       raise ArgumentError.new('Must provide an Array, or a Hash as the first Argument.')
    end

    arr
  end


  def self.reduce(collection, some_method)
    accumulator = ''
    counter = 0

    if collection.class == Array
      accumulator = collection[0]
      collection.each_with_index do |element, idx|
        if counter == 0
          counter = 1
          next
        end
        if some_method.class == String
          args = method(some_method).parameters.map { |arg| arg[1].to_s }
          if args.length < 3
            accumulator = method(some_method.to_sym).call(accumulator, element)
          else
            accumulator = method(some_method.to_sym).call(accumulator, element, idx)
          end
        elsif some_method.class == Symbol
          args = method(some_method).parameters.map { |arg| arg[1].to_s }
          if args.length < 3
            accumulator = method(some_method).call(accumulator, element)
          else
            accumulator = method(some_method).call(accumulator, element, idx)
          end
        elsif some_method.class == Method
          args = some_method.parameters.map { |arg| arg[1].to_s }
          if args.length < 3
            accumulator = some_method.call(accumulator, element)
          else
            accumulator = some_method.call(accumulator, element, idx)
          end
        end
      end
    elsif collection.class == Hash
      accumulator = collection.values[0]
      for k in collection
        if counter == 0
          counter = 1
          next
        else
          if some_method.class == String
            accumulator = method(some_method.to_sym).call(accumulator, k[1])
          elsif some_method.class == Symbol
            accumulator = method(some_method).call(accumulator, k[1])
          elsif some_method.class == Method
            accumulator = some_method.call(accumulator, k[1])
          end
        end
      end
    else
      return collection
    end

    accumulator
  end


end
