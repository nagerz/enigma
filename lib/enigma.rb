require './lib/key_creator'
require './lib/ceaser_cipher'

class Enigma
  include KeyCreator
  include CeaserCipher

  attr_reader :char_set

  def initialize
    @char_set = ("a".."z").to_a << " "
  end

  def encrypt(message, key = random_key, date = Date.today.strftime("%d%m%y"))
    keys = create_keys(key)
    offsets = create_offsets(date)
    shifts = create_shifts(keys, offsets)
    encrypted_message = []

    encrypted_message = encrypt_message(message, shifts)

    create_encryption(encrypted_message, key, date)
  end

  def create_offsets(date)
    offsets = []
    date_squared = (date.to_i**2).to_s
    date_squared.split(//).last(4).each do |offset|
      offsets << offset.to_i
    end
    offsets
  end

  def create_shifts(keys, offsets)
    shifts = [keys, offsets].transpose.map {|pair| pair.sum}
    shifts.map {|shift| shift % 27}
  end

  def encrypt_message(message, shifts)
    split_message = message.downcase.split(//)
    index = 0
    encrypted_message = []
    split_message.each do |letter|
      encrypted_message << encrypt_letter(letter, index, shifts)
      index += 1
    end
    encrypted_message.join
  end

  def encrypt_letter(letter, index, shifts)
    if @char_set.include?(letter)
      shift_letter(letter, index, shifts)
    else
      letter
    end
  end

  def create_encryption(encrypted_message, key, date)
    encrypted = {}
    encrypted[:encryption] = encrypted_message
    encrypted[:key] = key
    encrypted[:date] = date
    return encrypted
  end

  def decrypt(ciphertext, key, date = Date.today.strftime("%d%m%y"))
    create_keys(key)
    create_offsets(date)
    @shifts = [@keys,@offsets].transpose.map {|pair| pair.sum}
    simple_shifts = @shifts.map {|shift| shift % 27}

    decrypted_message = []
    split_cipher = ciphertext.downcase.split(//)
    split_index = 0
    split_cipher.each do |letter|
      if @char_set.include?(letter)
        if split_index % 4 == 0
          shift_index = (@char_set.index(letter) - simple_shifts[0]) % 27
          decrypted_letter = @char_set[shift_index]
          decrypted_message << decrypted_letter
        elsif split_index % 4 == 1
          shift_index = (@char_set.index(letter) - simple_shifts[1]) % 27
          decrypted_letter = @char_set[shift_index]
          decrypted_message << decrypted_letter
        elsif split_index % 4 == 2
          shift_index = (@char_set.index(letter) - simple_shifts[2]) % 27
          decrypted_letter = @char_set[shift_index]
          decrypted_message << decrypted_letter
        elsif split_index % 4 == 3
          shift_index = (@char_set.index(letter) - simple_shifts[3]) % 27
          decrypted_letter = @char_set[shift_index]
          decrypted_message << decrypted_letter
        end
      else
        decrypted_message << letter
      end
      split_index += 1
    end

    decrypted = {}
    decrypted[:decryption] = decrypted_message.join
    decrypted[:key] = key
    decrypted[:date] = date
    return decrypted
  end

  def crack(ciphertext, date = Date.today.strftime("%d%m%y"))
    cipher_letters = ciphertext.downcase.split(//).pop(4)
    hint = [" ", "e", "n", "d"]
    shift_index = (ciphertext.length % 4) - 1
    index = 3
    cipher_letters.each do |letter|
      shift = @char_set.index(cipher_letters[index]) - @char_set.index(hint[index])
      # shift = (shift + 27) % 27
      @shifts[shift_index] = shift
      index -= 1
      shift_index = (shift_index + 3) % 4
    end

    simple_shifts = @shifts.map {|shift| shift % 27}
    decrypted_message = []
    split_cipher = ciphertext.downcase.split(//)
    split_index = 0
    split_cipher.each do |letter|
      if @char_set.include?(letter)
        if split_index % 4 == 0
          shift_index = (@char_set.index(letter) - simple_shifts[0]) % 27
          decrypted_letter = @char_set[shift_index]
          decrypted_message << decrypted_letter
        elsif split_index % 4 == 1
          shift_index = (@char_set.index(letter) - simple_shifts[1]) % 27
          decrypted_letter = @char_set[shift_index]
          decrypted_message << decrypted_letter
        elsif split_index % 4 == 2
          shift_index = (@char_set.index(letter) - simple_shifts[2]) % 27
          decrypted_letter = @char_set[shift_index]
          decrypted_message << decrypted_letter
        elsif split_index % 4 == 3
          shift_index = (@char_set.index(letter) - simple_shifts[3]) % 27
          decrypted_letter = @char_set[shift_index]
          decrypted_message << decrypted_letter
        end
      else
        decrypted_message << letter
      end
      split_index += 1
    end

    create_offsets(date)
    keys = [simple_shifts, @offsets].transpose.map {|pair| pair[0] - pair[1]}
    key = crack_key(keys)

    decrypted = {}
    decrypted[:decryption] = decrypted_message.join
    decrypted[:date] = date
    decrypted[:key] = key

    return decrypted

  end


end
