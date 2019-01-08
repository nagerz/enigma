require './test/test_helper'
require 'date'
require 'timecop'
require './lib/enigma'

class EnigmaTest < Minitest::Test

  def setup
    @enigma = Enigma.new
    #Tested with today's date = 060119
    date = Time.local(2019, 1, 6)
    Timecop.freeze(date)
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
  end

  def test_it_has_attributes
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]

    assert_equal expected, @enigma.char_set
  end

  def test_it_creates_shift_keys
    key =  "02715"

    expected = [02, 27, 71, 15]
    assert_equal expected, @enigma.create_keys(key)
  end

  def test_it_creates_shift_offsets
    date = "040895"

    expected = [1, 0, 2, 5]
    assert_equal expected, @enigma.create_offsets(date)
  end

  def test_it_creates_shifts
    key =  "02715"
    keys = @enigma.create_keys(key)
    date =  "040895"
    offsets = @enigma.create_offsets(date)

    expected = [3, 0, 19, 20]
    assert_equal expected, @enigma.create_shifts(keys, offsets)
  end

  def test_it_encrypts_letters
    letter = "h"
    index = 0
    letter_2 = "!"
    index_2 = 1
    letter_3 = "z"
    index_3 = 2
    shifts = [4, 14, 1, 7]

    assert_equal "l", @enigma.encrypt_letter(letter, index, shifts)
    assert_equal "!", @enigma.encrypt_letter(letter_2, index_2, shifts)
    assert_equal " ", @enigma.encrypt_letter(letter_3, index_3, shifts)
  end

  def test_it_encrypts_message
    message = "hello world!"
    shifts = [4, 14, 1, 2]

    assert_equal "lsmnsnxqvze!", @enigma.encrypt_message(message, shifts)
  end

  def test_it_creates_encryption
    message = "encrypted text"
    key = "02715"
    date = "040895"

    expected = {
      encryption: "encrypted text",
      key: "02715",
      date: "040895"
      }

    assert_equal expected, @enigma.create_encryption(message, key, date)
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

  def test_it_defaults_to_todays_date
    encrypted = @enigma.encrypt("hello world", "02715")

    assert_equal "060119", encrypted[:date]
  end

  #Need better ways to test this
  def test_it_defaults_to_random_key
    encrypted = @enigma.encrypt("hello world")

    assert_equal 5, encrypted[:key].length

    expected = (0..99999).include?(encrypted[:key].to_i)

    assert_equal true, expected
  end

  def test_it_encrypts_with_todays_date
    expected = {
      encryption: "nfhauasdxm ",
      key: "02715",
      date: "060119"
      }

    actual = @enigma.encrypt("hello world", "02715")

    assert_equal expected, actual
  end

  #How to test?
  def test_it_encrypts_with_random_key_and_todays_date
    skip
    expected = {
      encryption: "random test",
      key: "02715",
      date: "060119"
      }

    assert_equal expected, @enigma.encrypt("hello world")
  end

  def test_it_decrypts
    skip
    expected = {
      decryption: "hello world",
      key: "02715",
      date: "040895"
      }

    actual = @enigma.decrypt("keder ohulw", "02715", "040895")

    assert_equal expected, actual
  end

  def test_it_decrypts_with_todays_date
    skip
    #Tested with today's date = 060119
    date = Time.local(2019, 1, 6)
    Timecop.freeze(date)

    encrypted = @enigma.encrypt("hello world", "02715")

    expected = {
      decryption: "hello world",
      key: "02715",
      date: "060119"
      }

    actual = @enigma.decrypt(encrypted[:encryption], "02715")

    assert_equal expected, actual
  end

  def test_it_can_crack_with_a_date
    skip
    expected = {
      decryption: "hello world end",
      date: "291018",
      key: "08304"
    }

    actual = @enigma.crack("vjqtbeaweqihssi", "291018")

    assert_equal expected, actual
  end

  def test_it_can_crack_with_todays_date
    skip
    #Tested with today's date = 060119
    date = Time.local(2019, 1, 6)
    Timecop.freeze(date)

    expected = {
      decryption: "hello world end",
      date: "060119",
      key: ""
    }

    actual = @enigma.crack("vjqtbeaweqihssi")

    assert_equal expected, actual
  end

  def test_it_can_crack_with_todays_date2
    skip
    date = Time.local(2019, 1, 7)
    Timecop.freeze(date)

    expected = {
      decryption: "hello world end",
      date: "070119",
      key: "45108"
    }

    actual = @enigma.crack("fuugmpejpamvccm")

    assert_equal expected, actual
  end

end
