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

end
