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

  def encrypt(message, key, date = Date.today.strftime("%d%m%y"))
    create_keys(key)
    create_offsets(date)
    @shifts = [@keys,@offsets].transpose.map {|pair| pair.sum}
    simple_shifts = @shifts.map {|shift| shift % 27}

    encrypted_message = []
    split_message = message.downcase.split(//)
    split_index = 0
    split_message.each do |letter|
      if @char_set.include?(letter)
        if split_index % 4 == 0
          shift_index = (@char_set.index(letter) + simple_shifts[0]) % 27
          encrypted_letter = @char_set[shift_index]
          encrypted_message << encrypted_letter
        elsif split_index % 4 == 1
          shift_index = (@char_set.index(letter) + simple_shifts[1]) % 27
          encrypted_letter = @char_set[shift_index]
          encrypted_message << encrypted_letter
        elsif split_index % 4 == 2
          shift_index = (@char_set.index(letter) + simple_shifts[2]) % 27
          encrypted_letter = @char_set[shift_index]
          encrypted_message << encrypted_letter
        elsif split_index % 4 == 3
          shift_index = (@char_set.index(letter) + simple_shifts[3]) % 27
          encrypted_letter = @char_set[shift_index]
          encrypted_message << encrypted_letter
        end
      else
        encrypted_message << letter
      end
      split_index += 1
    end

    encrypted = {}
    encrypted[:encryption] = encrypted_message.join
    encrypted[:key] = key
    encrypted[:date] = date
    return encrypted
  end

  def create_offsets(date)
    date_squared = (date.to_i**2).to_s
    date_squared.split(//).last(4).each do |offset|
      @offsets << offset.to_i
    end
  end


end
