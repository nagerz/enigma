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

  def test_it_has_attributes
    assert_equal [], @enigma.keys
    assert_equal [], @enigma.offsets
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

  def test_it_encrypts
    skip
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

  def test_it_encrypts_with_todays_date
    skip
    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
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
