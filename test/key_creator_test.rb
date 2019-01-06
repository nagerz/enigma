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

end
