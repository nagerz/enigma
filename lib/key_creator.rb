module KeyCreator

  def create_keys(key)
    pairs = []
    keys = []
    key.chars.each_cons(2) {|a| pairs << a}
    pairs.map do |pair|
      keys << pair.join.to_i
    end
    keys
  end

  def random_key
    sprintf '%05d', rand(1..99999)
  end

  def alt_crack_key

  end

  def crack_key(keys)
    unjoined_key_pairs = find_key_pairs(keys)
    unjoined_key_pairs[0]+unjoined_key_pairs[1][1]+unjoined_key_pairs[2][1]+unjoined_key_pairs[3][1]
  end

  def find_key_pairs(keys)
    key_arrays = []
    first_remainder_values = remainder_values(keys[0])
    first_remainder_values.each do |value|
      @key_pairs = []
      key_arrays << check_next_remainder_value(keys, value)
    end
    key_arrays.flatten
  end

  def remainder_values(key)
    if key < 0
      key += 27
    end
    values = (0..99).find_all {|i| i%27 == key}
    values.map do |value|
      value = sprintf '%02d', value
    end
  end

  def check_next_remainder_value(keys, value, index = 1)
    next_remainder_set = remainder_values(keys[index])
    next_remainder_value = find_matching_sequential_key(value, next_remainder_set)
    if !next_remainder_value.nil?
      @key_pairs << value
      if @key_pairs.length < 3
        index += 1
        check_next_remainder_value(keys, next_remainder_value, index)
      elsif @key_pairs.length == 3
        @key_pairs << next_remainder_value
        return @key_pairs
      end
    elsif next_remainder_value.nil?
      @key_pairs = []
    end
  end

  def find_matching_sequential_key(key, remainder_set)
    remainder_set.find do |value|
      value = sprintf '%02d', value
      key[1] == value[0]
    end
  end

end
