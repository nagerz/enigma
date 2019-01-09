require './lib/key_creator'
require './lib/cryptor'
require './lib/ceaser_cipher'
require './lib/cracker'
require 'date'

class Enigma
  include KeyCreator
  include CeaserCipher
  include Cryptor
  include Cracker

  attr_reader :char_set
  attr_accessor :key_pairs

  def initialize
    @char_set = ("a".."z").to_a << " "
    @key_pairs = []
  end

  def encrypt(message, key = random_key, date = Date.today.strftime("%d%m%y"))
    translate(message, key, date, "encrypt")
  end

  def decrypt(ciphertext, key, date = Date.today.strftime("%d%m%y"))
    translate(ciphertext, key, date, "decrypt")
  end

  def crack(ciphertext, date = Date.today.strftime("%d%m%y"))
    crack_cipher(ciphertext, date, "decrypt")
  end


end
