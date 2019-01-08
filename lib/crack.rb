require './lib/enigma'
require 'date'

message = File.read(ARGV[0])
date = ARGV[3]


enigma = Enigma.new
decrypted = enigma.crack(message, date)

cracked_file = File.open(ARGV[1], "w")
cracked_file.write(decrypted[:decryption])
cracked_file.close

puts "Created '#{ARGV[1]}' with the cracked key #{decrypted[:key]} and date #{decrypted[:date]}"
