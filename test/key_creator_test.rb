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

end
