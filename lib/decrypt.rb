require './lib/enigma'
require 'date'

message = File.read(ARGV[0])
key = ARGV[2]
date = ARGV[3]


enigma = Enigma.new
decrypted = enigma.decrypt(message, key, date)

decrypted_file = File.open(ARGV[1], "w")
decrypted_file.write(decrypted[:decryption])
decrypted_file.close

puts "Created '#{ARGV[1]}' with the key #{decrypted[:key]} and date #{decrypted[:date]}"
