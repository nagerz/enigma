require './test/test_helper'
require 'date'
require 'timecop'
require './lib/enigma'

class EnigmaTest < Minitest::Test

  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
  end

  def test_it_has_attributes
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]

    assert_equal [], @enigma.keys
    assert_equal [], @enigma.offsets
    assert_equal [], @enigma.shifts
    assert_equal expected, @enigma.char_set
  end

  def test_it_creates_shift_keys
    @enigma.encrypt("hello world", "02715", "040895")

    expected = [02, 27, 71, 15]
    assert_equal expected, @enigma.keys
  end

  def test_it_creates_shift_offsets
    @enigma.encrypt("hello world", "02715", "040895")

    expected = [1, 0, 2, 5]
    assert_equal expected, @enigma.offsets
  end

  def test_it_creates_shifts
    @enigma.encrypt("hello world", "02715", "040895")

    expected = [3, 27, 73, 20]
    assert_equal expected, @enigma.shifts
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
    skip
    expected = {
      decryption: "hello world",
      key: "02715",
      date: "040895"
      }

    actual = @enigma.decrypt("keder ohulw", "02715", "040895")

    assert_equal expected, actual
  end

  def test_it_defaults_to_todays_date
    #Tested with today's date = 060119
    date = Time.local(2019, 1, 6)
    Timecop.freeze(date)

    @enigma.encrypt("hello world", "02715")

    expected = [4, 1, 6, 1]

    assert_equal expected, @enigma.offsets
  end

  #Need better ways to test this
  def test_it_defaults_to_random_key
    #Tested with today's date = 060119
    date = Time.local(2019, 1, 6)
    Timecop.freeze(date)

    @enigma.encrypt("hello world")

    assert_equal 5, @enigma.encrypt[:key].length

    expected = @enigma.keys.all? do |key|
      (0..99).includes?(key)
    end

    assert_equal true, expected
  end

  def test_it_encrypts_with_todays_date
    #Tested with today's date = 060119
    date = Time.local(2019, 1, 6)
    Timecop.freeze(date)

    expected = {
      encryption: "nfhauasdxm ",
      key: "02715",
      date: "060119"
      }

    actual = @enigma.encrypt("hello world", "02715")

    assert_equal expected, actual
  end

  def test_it_decrypts_with_todays_date
    skip
    expected = {
      decryption: "hello world",
      key: "02715",
      date: "040895"
      }

    actual = @enigma.decrypt(encrypted[:encryption], "02715")

    assert_equal expected, actual
  end

  def test_it_encrypts_with_random_key_and_todays_date
    skip
    expected = {
      decryption: "hello world",
      key: "02715",
      date: "040895"
      }

    actual = @enigma.encrypt("hello world")

    assert_equal expected, actual
  end

end
