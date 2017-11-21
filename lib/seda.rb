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
    seen = {}

    iterables = (eval(local_variables[0].to_s))[0..-1]

    iterables.flatten.each do |element|
      seen[element] == nil ? seen[element] = 1 : seen[element] += 1
    end

    for k in seen
      if k[1] == iterables.length
        result << k[0]
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


  def self.difference(*arrays)
    checker = (eval(local_variables[0].to_s))[0]
    iterables = (eval(local_variables[0].to_s))[1..-1]

    arr = []
    seen = {}

    checker.each do |element|
      seen[element] = element
      arr << element
    end

    iterables.each do |inner_arr|
      inner_arr.each do |element|
        if seen[element]
          arr = arr.reject{|el| el == element}
        end
      end
    end

    arr
  end


  def self.delay(some_method, wait, *some_method_args)
    args = eval(local_variables[2].to_s)
    if some_method.class == Method
      sleep (wait.to_f/1000)
      some_method.call(*args)
    elsif some_method.class == Symbol
      sleep (wait.to_f/1000)
      method(some_method).call(*args)
    elsif some_method.class == String
      sleep (wait.to_f/1000)
      method(some_method.to_sym).call(*args)
    else
      raise ArgumentError.new('First argument must reference a method')
    end
  end


  def self.every(collection, some_method)
    collection.each do |item|
      if some_method.class == Method
        if !some_method.call(item)
          return false
        end
      elsif some_method.class == Symbol
        if !method(some_method).call(item)
          return false
        end
      elsif some_method.class == String
        if !method(some_method.to_sym).call(item)
          return false
        end
      else
        raise ArgumentError.new('First argument must reference a method')
      end
    end
    return true
  end


  def self.flatten(nested_array, result = [])
    nested_array.each do |element|
      if element.class == Array
        self.flatten(element, result)
      else
        result << element
      end
    end

    result
  end


  def self.map(collection, some_method)
    arr = []

    if collection.class == Array
      collection.each_with_index do |element, idx|
        if some_method.class == String
          arr << method(some_method.to_sym).call(element, idx, collection)
        elsif some_method.class == Symbol
          arr << method(some_method).call(element, idx, collection)
        elsif some_method.class == Method
          arr << some_method.call(element, idx, collection)
        else
          raise ArgumentError.new('The second argument must be a method. You could pass in the actual method, a string of the method name, or a symbol of the method name. Both arguments are needed.')
        end
      end
    elsif collection.class == Hash
      for k in collection
        if some_method.class == String
          arr << method(some_method.to_sym).call(k[1], k[0], collection)
        elsif some_method.class == Symbol
          arr << method(some_method).call(k[1], k[0], collection)
        elsif some_method.class == Method
          arr << some_method.call(k[1], k[0], collection)
        else
          raise ArgumentError.new('The second argument must be a method. You could pass in the actual method, a string of the method name, or a symbol of the method name. Both arguments are needed.')
        end
      end
    else
       raise ArgumentError.new('Must provide an Array, or a Hash as the first Argument.')
    end

    arr
  end


  def self.memoize(some_method, *some_method_args)
    storage = {}
    result = ''
    b = eval(local_variables[1].to_s)

    if some_method.class == String
      some_method = method(some_method.to_sym)
    elsif some_method.class == Symbol
      some_method = method(some_method)
    end

    result = lambda{|a = b, arg = b.to_json|
      if !storage[arg]
        storage[arg] = some_method.call(*a)
      end

      return storage[arg]
    }

    return result.call(b)
  end


  def self.some(collection, some_method)
    collection.each do |item|
      if some_method.class == Method
        return !some_method.call(item)
      elsif some_method.class == Symbol
        return !method(some_method).call(item)
      elsif some_method.class == String
        return !method(some_method.to_sym).call(item)
      else
        raise ArgumentError.new('First argument must reference a method')
      end
    end

    return true
  end






end
