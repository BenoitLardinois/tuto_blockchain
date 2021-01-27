require 'digest'
require 'pp'

class Block
	attr_reader :index, :timestamp, :data, :previous_hash, :hash

	def initialize(index, data, previous_hash)
		@index = index
		@timestamp = Time.now
		@data = data
		@previous_hash = previous_hash

#Stockage d'un autre méthode qui permet de hasher et stocker les données!
		@hash = compute_hash
	end

	def compute_hash
#Création d'une clé privé qui sera tout le temps la vôtre celon votre ordi.
		sha = Digest::SHA256.new
#On passe toute les données dans le block pour les hasher de manière unique.
		sha.update( @index.to_s + 
								@timestamp.to_s + 
								@data + 
								@previous_hash )#Pour les update c'est + et non ,
		sha.hexdigest
	end

	def self.first(data)
		Block.new(0, data, "0")
	end

	def self.next(previous, data)
		Block.new(previous.index+1, data, previous.hash)
	end
	
end

b0 = Block.first("THP")
b1 = Block.next(b0, "THPP")
b2 = Block.next(b1, "more data")
b3 = Block.next(b2, "hello there!")

pp [b0, b1, b2, b3]#Grâce a la gem PrettyPrinter permet d'imprimer sur le terminal des belles choses