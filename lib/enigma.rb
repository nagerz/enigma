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

    encrypted_message = encrypt_message(message, shifts, "encrypt")

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

  def encrypt_message(message, shifts, type)
    split_message = message.downcase.split(//)
    index = 0
    encrypted_message = []
    split_message.each do |letter|
      encrypted_message << encrypt_letter(letter, index, shifts, type)
      index += 1
    end
    encrypted_message.join
  end

  def encrypt_letter(letter, index, shifts, type)
    if @char_set.include?(letter)
      shift_letter(letter, index, shifts, type)
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
    keys = create_keys(key)
    offsets = create_offsets(date)
    shifts = create_shifts(keys, offsets)

    decrypted_message = encrypt_message(ciphertext, shifts, "decrypt")

    create_decryption(decrypted_message, key, date)
  end

  def create_decryption(decrypted_message, key, date)
    decrypted = {}
    decrypted[:decryption] = decrypted_message
    decrypted[:key] = key
    decrypted[:date] = date
    return decrypted
  end

  def crack(ciphertext, date = Date.today.strftime("%d%m%y"))
    shift_rotate = find_shift_rotate(ciphertext)
    crack_letters = clean_cipher_message(ciphertext).pop(4)
    end_shifts = find_end_shifts(hint_indexes, crack_indexes(crack_letters))
    shifts = end_shifts.rotate(shift_rotate)

    decrypted_message = encrypt_message(ciphertext, shifts, "decrypt")

    offsets = create_offsets(date)
    keys = [shifts, offsets].transpose.map {|pair| pair[0] - pair[1]}
    key = crack_key(keys)

    decrypted = {}
    decrypted[:decryption] = decrypted_message
    decrypted[:date] = date
    decrypted[:key] = key

    return decrypted
  end

  def find_shift_rotate(text)
    ((clean_cipher_message(text).length - 3) % 4) + 1
  end

  def clean_cipher_message(text)
    cipher_letters = text.downcase.split(//)
    cipher_letters.select {|letter| @char_set.include?(letter)}
  end

  def hint_indexes
    hint = [" ", "e", "n", "d"]
    hint.map do |letter|
      @char_set.index(letter)
    end
  end

  def crack_indexes(crack_letters)
    crack_letters.map do |letter|
      @char_set.index(letter)
    end
  end

  def find_end_shifts(hints, cracks)
    shifts = [hints, cracks].transpose.map {|pair| pair[0] - pair[1]}
    shifts.map {|shift| 27 - (shift % 27)}
  end


end
