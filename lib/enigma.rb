require './lib/key_creator'

class Enigma
  include KeyCreator

  attr_reader :keys, :offsets

  def initialize
    @keys = []
    @offsets = []
  end

  def encrypt(message, key, date)
    create_keys(key)
    create_offsets(date)
  end

  def create_offsets(date)
    date_squared = (date.to_i**2).to_s
    date_squared.split(//).last(4).each do |offset|
      @offsets << offset.to_i
    end
  end


end
