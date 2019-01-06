class Enigma
  attr_reader :keys, :offsets

  def initialize
    @keys = []
    @offsets = []
  end

  def encrypt(message, key, date)
    @keys = create_keys(key)
    create_offsets(date)
  end

end
