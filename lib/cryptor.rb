module Cryptor

  def translate(message, key, date, type)
    keys = create_keys(key)
    offsets = create_offsets(date)
    shifts = create_shifts(keys, offsets)

    translated_message = translate_message(message, shifts, type)

    create_cryption(translated_message, key, date, type)
  end

  def create_offsets(date)
    offsets = []
    date_squared = (date.to_i**2).to_s
    date_squared.split(//).last(4).each do |offset|
      offsets << offset.to_i
    end
    offsets
  end

  def create_shifts(keys, offsets)
    shifts = [keys, offsets].transpose.map {|pair| pair.sum}
    shifts.map {|shift| shift % 27}
  end

  def translate_message(message, shifts, type)
    split_message = message.downcase.split(//)
    translated_message = []
    index = 0
    split_message.each do |letter|
      if @char_set.include?(letter)
        translated_message << shift_letter(letter, index, shifts, type)
        index += 1
      else
        translated_message << letter
      end
    end
    translated_message.join
  end

  def create_cryption(crypted_message, key, date, type)
    crypted = {}
    crypted[:key] = key
    crypted[:date] = date
    if type == "encrypt"
      crypted[:encryption] = crypted_message
    elsif type == "decrypt"
      crypted[:decryption] = crypted_message
    end
    return crypted
  end

end
