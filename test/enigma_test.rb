require './test/test_helper'
require 'date'
require './lib/enigma'

class EnigmaTest < Minitest::Test

  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
  end

  def test_it_has_character_set
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
       "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]

    assert_equal expected, @enigma.char_set
  end

  def test_it_creates_shift_keys
    key =  "02715"
    key_2 = "95782"

    assert_equal [02, 27, 71, 15], @enigma.create_keys(key)
    assert_equal [95, 57, 78, 82], @enigma.create_keys(key_2)
  end

  def test_it_creates_shift_offsets
    date = "040895"
    date_2 = "080119"

    assert_equal [1, 0, 2, 5], @enigma.create_offsets(date)
    assert_equal [4, 1, 6, 1], @enigma.create_offsets(date_2)
  end

  def test_it_creates_shifts
    key =  "02715"
    keys = @enigma.create_keys(key)
    key_2 =  "95782"
    keys_2 = @enigma.create_keys(key_2)
    date =  "040895"
    offsets = @enigma.create_offsets(date)
    date_2 =  "080119"
    offsets_2 = @enigma.create_offsets(date_2)

    assert_equal [3, 0, 19, 20], @enigma.create_shifts(keys, offsets)
    assert_equal [18, 4, 3, 2], @enigma.create_shifts(keys_2, offsets_2)
  end

  def test_it_encrypts_letters
    letter = "h"
    index = 0
    letter_2 = "a"
    index_2 = 5
    letter_3 = "z"
    index_3 = 34
    shifts = [4, 14, 1, 7]

    assert_equal "l", @enigma.shift_letter(letter, index, shifts, "encrypt")
    assert_equal "o", @enigma.shift_letter(letter_2, index_2, shifts, "encrypt")
    assert_equal " ", @enigma.shift_letter(letter_3, index_3, shifts, "encrypt")
  end

  def test_it_decrypts_letters
    letter = "l"
    index = 0
    letter_2 = "o"
    index_2 = 5
    letter_3 = " "
    index_3 = 34
    shifts = [4, 14, 1, 7]

    assert_equal "h", @enigma.shift_letter(letter, index, shifts, "decrypt")
    assert_equal "a", @enigma.shift_letter(letter_2, index_2, shifts, "decrypt")
    assert_equal "z", @enigma.shift_letter(letter_3, index_3, shifts, "decrypt")
  end

  def test_it_encrypts_message
    message_1 = "hello world".downcase.split(//)
    message_2 = "HEllo worLd!".downcase.split(//)
    message_3 = "HE$llo worLd!".downcase.split(//)

    shifts = [4, 14, 1, 2]

    assert_equal "lsmnsnxqvze", @enigma.translate_message(message_1, shifts, "encrypt")
    assert_equal "lsmnsnxqvze!", @enigma.translate_message(message_2, shifts, "encrypt")
    assert_equal "ls$mnsnxqvze!", @enigma.translate_message(message_3, shifts, "encrypt")
  end

  def test_it_decrypts_message
    message_1 = "lsmnsnxqvze".downcase.split(//)
    message_2 = "lsmnsnxqvze!".downcase.split(//)
    message_3 = "test me".downcase.split(//)

    shifts = [4, 14, 1, 2]

    assert_equal "hello world", @enigma.translate_message(message_1, shifts, "decrypt")
    assert_equal "hello world!", @enigma.translate_message(message_2, shifts, "decrypt")
    assert_equal "prrrwzd", @enigma.translate_message(message_3, shifts, "decrypt")
  end

  def test_it_creates_cryption
    message_1 = "encrypted text"
    message_2 = "decrypted text"

    key = "02715"
    date = "040895"

    expected_1 = {
      encryption: "encrypted text",
      key: "02715",
      date: "040895"
      }

    expected_2 = {
      decryption: "decrypted text",
      key: "02715",
      date: "040895"
      }

    assert_equal expected_1, @enigma.create_cryption(message_1, key, date, "encrypt")
    assert_equal expected_2, @enigma.create_cryption(message_2, key, date, "decrypt")
  end

  def test_it_encrypts
    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
      }

    actual = @enigma.encrypt("hello world", "02715", "040895")

    assert_equal expected, actual
  end

  def test_it_decrypts
    expected = {
      decryption: "hello world",
      key: "02715",
      date: "040895"
      }

    actual = @enigma.decrypt("keder ohulw", "02715", "040895")

    assert_equal expected, actual
  end

  def test_it_defaults_to_todays_date
    encrypted = @enigma.encrypt("hello world", "02715")

    assert_equal 6, encrypted[:date].length
  end

  def test_it_defaults_to_random_key
    encrypted = @enigma.encrypt("hello world")
    assert_equal 5, encrypted[:key].length

    actual = (0..99999).include?(encrypted[:key].to_i)
    assert_equal true, actual
  end

  def test_it_encrypts_with_todays_date
    message = "Hello w!orld"
    encrypted = @enigma.encrypt(message, "02715")

    assert_equal message.length, encrypted[:encryption].length
    assert_equal "02715", encrypted[:key]
    assert_equal Date.today.strftime("%d%m%y"), encrypted[:date]
  end

  def test_it_decrypts_with_todays_date
    encrypted = @enigma.encrypt("hello world", "02715")

    expected = {
      decryption: "hello world",
      key: "02715",
      date: Date.today.strftime("%d%m%y")
      }

    actual = @enigma.decrypt(encrypted[:encryption], "02715")

    assert_equal expected, actual
  end

  ###Crack Tests
  def test_it_can_clean_cipher_message
    text = "H83hb 89&nj"

    assert_equal ["h","h","b"," ","n","j"], @enigma.clean_cipher_message(text)
  end

  def test_it_can_find_shift_rotate
    text = "H83hb 89&nj"

    assert_equal 4, @enigma.find_shift_rotate(text)
  end

  def test_it_can_find_hint_indexes
    assert_equal [26, 4, 13, 3], @enigma.hint_indexes
  end

  def test_it_can_find_crack_indexes
    sample_letters = ["t","e","s","t"]

    assert_equal [19, 4, 18, 19], @enigma.crack_indexes(sample_letters)
  end

  def test_it_can_find_end_shifts
    crack_indexes = [19, 4, 18, 19]
    hint_indexes = [26, 4, 13, 3]

    actual = @enigma.find_end_shifts(crack_indexes, hint_indexes)

    assert_equal [20, 0, 5, 16], actual
  end

  def test_it_can_crack_with_a_date
    expected = {
      decryption: "hello world end",
      date: "291018",
      key: "08304"
    }

    actual = @enigma.crack("vjqtbeaweqihssi", "291018")

    assert_equal expected[:decryption], actual[:decryption]
    assert_equal expected[:date], actual[:date]
    assert_equal 5, actual[:key].length
  end

  def test_it_can_crack_with_todays_date
    expected = {
      decryption: "hello world end!$",
      date: Date.today.strftime("%d%m%y"),
      key: "XXXXX"
    }

    actual = @enigma.crack("fuugmpejpamvccm!$")

    assert_equal expected[:decryption], actual[:decryption]
    assert_equal expected[:date], actual[:date]
    assert_equal 5, actual[:key].length
  end

end
