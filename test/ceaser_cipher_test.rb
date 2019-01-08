require './test/test_helper'
require './lib/ceaser_cipher'

class CeaserRepo
  include CeaserCipher

  attr_reader :char_set

  def initialize
    @char_set = ("a".."z").to_a << " "
  end

end

class CeaserCipherTest < Minitest::Test

  def setup
    @ceaser = CeaserRepo.new
  end

  def test_it_exists
    expected = CeaserRepo.included_modules.include?(CeaserCipher)

    assert_equal true, expected
  end

  def test_it_shifts_letter
    letter = "h"
    index = 0
    letter_2 = "e"
    index_2 = 1
    letter_3 = "e"
    index_3 = 6
    shifts = [4, 14, 1, 7]

    assert_equal "l", @ceaser.shift_letter(letter, index, shifts)
    assert_equal "s", @ceaser.shift_letter(letter_2, index_2, shifts)
    assert_equal "f", @ceaser.shift_letter(letter_3, index_3, shifts)
  end

end
