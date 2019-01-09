require './test/test_helper'
require './lib/key_creator'

class KeyCreatorRepo

  include KeyCreator

  attr_reader :keys

  def initialize(key)
    @keys = []
  end

end

class KeyCreatorTest < Minitest::Test

  def setup
    @key = "02715"
    @key_creator = KeyCreatorRepo.new(@key)
  end

  def test_it_exists
    expected = KeyCreatorRepo.included_modules.include?(KeyCreator)

    assert_equal true, expected
  end

  def test_it_can_split_key_into_integer_pairs
    expected = [02, 27, 71, 15]

    assert_equal expected, @key_creator.create_keys(@key)
  end

  def test_it_can_generate_random_key
    assert_instance_of String, @key_creator.random_key
    assert_equal 5, @key_creator.random_key.length
    assert_equal true, (1..99999).include?(@key_creator.random_key.to_i)
  end

  def test_it_can_split_random_key_into_integer_pairs
    key = @key_creator.random_key

    assert_equal 4, @key_creator.create_keys(key).length
  end
  
  ###Crack key tests. Couldn't get to key.
  def test_it_can_find_remainder_values_set
    key = 8
    remainder_set = ["08", "35", "62", "89"]

    assert_equal remainder_set, @key_creator.remainder_values(key)
  end

  def test_it_can_find_matching_sequential_key
    key = "08"
    remainder_set = ["2", "29", "56", "83"]

    assert_equal "83", @key_creator.find_matching_sequential_key(key, remainder_set)
  end

  def test_it_finds_key_pairs
    keys = [8, 2, 3, 4]
    key_pairs = ["08", "83", "30", "04"]

    assert_equal key_pairs, @key_creator.find_key_pairs(keys)
  end

  def test_it_finds_cracked_code_key
    skip
    keys = [8, 2, 3, 4]

    assert_equal "08304", @key_creator.crack_key(keys)
  end

  def test_it_cracks_key
  date = "040895"
  shifts = [3, 0, 19, 20]

  assert_equal "02715", @enigma.crack_key(date, shifts)
  end

end
