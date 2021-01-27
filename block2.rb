require 'digest'
require 'pp'

LEDGER = []

class Block
	attr_reader :index, :nonce, :timestamp, :transaction, :transaction_count, :data, :previous_hash, :hash #nonce = number once

	def initialize(index, transaction, previous_hash)
		@index = index
		@timestamp = Time.now
		@transaction = transaction
		@transaction_count = transaction.size
		@previous_hash = previous_hash
		@hash, @nonce = compute_hash_with_proof_of_work
	end

	def compute_hash_with_proof_of_work(difficulty="0")
		nonce = 0
		loop do 
			hash = compute_hash_with_nonce(nonce)
			if hash.start_with?(difficulty)
				return [hash, nonce]
			else
				nonce += 1
				print "#{nonce} - "
			end
		end
	end

	def compute_hash_with_nonce(nonce=0)
		sha = Digest::SHA256.new
		sha.update( @index.to_s + 
								nonce.to_s +
								@timestamp.to_s + 
								@transaction.to_s +
								@transaction_count.to_s + 
								@previous_hash )
		sha.hexdigest
	end

	def self.first(*transaction)
		Block.new(0, transaction, "0")
	end

	def self.next(previous, transaction)
		Block.new(previous.index+1, transaction, previous.hash)
	end

end

#3 méthode qui doivent être dans un autre fichier !!!
def create_first_block
	i = 0
	instance_variable_set("@b#{i}", Block.first({ from: "Benoit", to: "THP", what: "Beacoup de love", qty: "100"}))
	LEDGER << @b0
	pp @b0
	add_block
end

def add_block
	i = 1
	loop do
		instance_variable_set("@b#{i}", Block.next(instance_variable_get("@b#{i-1}"), get_transaction)) 
		LEDGER << instance_variable_get("@b#{i}")
		puts "=============================="
		pp instance_variable_get("@b#{i}")
		puts "=============================="
		i += 1
	end
end

def get_transaction
	transaction_block ||= [] #||= renfait une transaction avec un array vide
	blank_transaction = Hash[from: "", to: "", what: "", qty: ""]
	loop do
		puts ""
		puts "Enter your name for the new transaction"
		from = gets.chomp
		puts ""
		puts "What do you want to send ?"
		what = gets.chomp
		puts ""
		puts "In how much quantity?"
		qty = gets.chomp
		puts ""
		puts "for who ? :)"
		to = gets.chomp

		transaction = Hash[from: "#{from}", what: "#{what}", qty: "#{qty}", to: "#{to}"]
		transaction_block << transaction

		puts ""
		puts "Do you want to make another transaction? (Y/n)"
		new_transaction = gets.chomp.downcase

		if new_transaction == "y"
			self
		else
			return transaction_block
			break
		end
	end
end

create_first_block