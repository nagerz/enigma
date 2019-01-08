module CeaserCipher

  def shift_letter(letter, index, shifts, type)
    letter_index = @char_set.index(letter)
    shift_index = index % 4
    shift = shifts[shift_index]
    if type == "encrypt"
      @char_set.rotate(shift)[letter_index]
    elsif type == "decrypt"
      @char_set.rotate(shift*-1)[letter_index]
    end


  end
  #
  #
  #
  #   if split_index % 4 == 0
  #     shift_index = (@char_set.index(letter) + shifts[0]) % 27
  #     encrypted_letter = @char_set[shift_index]
  #     encrypted_message << encrypted_letter
  #   elsif split_index % 4 == 1
  #     shift_index = (@char_set.index(letter) + shifts[1]) % 27
  #     encrypted_letter = @char_set[shift_index]
  #     encrypted_message << encrypted_letter
  #   elsif split_index % 4 == 2
  #     shift_index = (@char_set.index(letter) + shifts[2]) % 27
  #     encrypted_letter = @char_set[shift_index]
  #     encrypted_message << encrypted_letter
  #   elsif split_index % 4 == 3
  #     shift_index = (@char_set.index(letter) + shifts[3]) % 27
  #     encrypted_letter = @char_set[shift_index]
  #     encrypted_message << encrypted_letter
  #   end
  # end

end
