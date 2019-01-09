module Cracker

  def crack_cipher(ciphertext, date, type)
    crack_letters = clean_cipher_message(ciphertext).pop(4)
    shift_rotate = find_shift_rotate(ciphertext)
    end_shifts = find_end_shifts(crack_indexes(crack_letters), hint_indexes)
    shifts = end_shifts.rotate(shift_rotate)

    decrypted_message = translate_message(ciphertext.downcase.split(//), shifts, type)

    key = "XXXXX"
    create_cryption(decrypted_message, key, date, type)
  end

  def clean_cipher_message(text)
    cipher_letters = text.downcase.split(//)
    cipher_letters.select {|letter| @char_set.include?(letter)}
  end

  def find_shift_rotate(text)
    (clean_cipher_message(text).length % 4) + 2
  end

  def hint_indexes
    hint = [" ", "e", "n", "d"]
    hint.map do |letter|
      @char_set.index(letter)
    end
  end

  def crack_indexes(crack_letters)
    crack_letters.map do |letter|
      @char_set.index(letter)
    end
  end

  def find_end_shifts(cracks, hints)
    shifts = [cracks, hints].transpose.map {|pair| pair[0] - pair[1]}
    shifts.map {|shift| shift % 27}
  end

end
