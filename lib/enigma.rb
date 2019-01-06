require './lib/key_creator'

class Enigma
  include KeyCreator

  attr_reader :keys, :offsets, :shifts, :char_set

  def initialize
    @keys = []
    @offsets = []
    @shifts = []
    @char_set = ("a".."z").to_a << " "
  end

  def encrypt(message, key, date)
    create_keys(key)
    create_offsets(date)
    @shifts = [@keys,@offsets].transpose.map {|pair| pair.sum}

    split_message = message.split(//)
    split_message.each do |letter|
      if @char_set.include?(letter)
        if split_message.index(letter) % 4 == 0
          letter.to_i
  end

  def create_offsets(date)
    date_squared = (date.to_i**2).to_s
    date_squared.split(//).last(4).each do |offset|
      @offsets << offset.to_i
    end
  end


end
