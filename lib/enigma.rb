require './lib/key_creator'

class Enigma
  include KeyCreator

  attr_reader :keys, :offsets

  def initialize
    @keys = []
    @offsets = []
  end

  def encrypt(message, key, date)
    @keys = create_keys(key)
    @offsets = create_offsets(date)
  end

  def create_offsets(date)
  end


end
