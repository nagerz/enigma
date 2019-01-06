module KeyCreator

  def create_keys(key)
    pairs = []
    key.chars.each_cons(2) {|a| pairs << a}
    pairs.map do |pair|
      @keys << pair.join.to_i
    end
  end

  def generate_key
  end

end
