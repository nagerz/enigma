module Cryptor

  def translate(message, key, date, type)
    keys = create_keys(key)
    offsets = create_offsets(date)
    shifts = create_shifts(keys, offsets)

    split_message = message.downcase.split(//)
    translated_message = translate_message(split_message, shifts, type)

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

  def translate_message(split_message, shifts, type)
    translated_message = []
    index = 0
    split_message.each do |letter|
      translated_message << translate_letter(letter, index, shifts, type)
      index += 1 if @char_set.include?(letter)
    end
    translated_message.join
  end

  def translate_letter(letter, index, shifts, type)
    if @char_set.include?(letter)
      shift_letter(letter, index, shifts, type)
    else
      letter
    end
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
