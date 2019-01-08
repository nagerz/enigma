module CeaserCipher

  def shift_letter(letter, index, shifts, type)
    letter_index = @char_set.index(letter)
    shift_index = index % 4
    shift = shifts[shift_index]
    if type == "encrypt"
      @char_set.rotate(shift)[letter_index]
    elsif type == "decrypt"
      @char_set.rotate(shift * -1)[letter_index]
    end
  end
  
end
