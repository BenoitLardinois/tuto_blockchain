require 'digest'
require 'pp'

LEDGER = []

class Block
	attr_reader :index, :nonce, :timestamp, :data, :previous_hash, :hash #nonce = number once

	def initialize(index, data, previous_hash)
		@index = index
		@timestamp = Time.now
		@data = data
		@previous_hash = previous_hash

#Stockage d'un autre méthode qui permet de hasher et stocker les données!
		@hash, @nonce = compute_hash_with_proof_of_work
	end

	def compute_hash_with_proof_of_work(difficulty="00")
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
#Création d'une clé privé qui sera tout le temps la vôtre celon votre ordi.
		sha = Digest::SHA256.new
#On passe toute les données dans le block pour les hasher de manière unique.
		sha.update( @index.to_s + 
								nonce.to_s +
								@timestamp.to_s + 
								@data + 
								@previous_hash )#Pour les update c'est + et non ,
		sha.hexdigest
	end

#Premier block qui na pas de hash précédent (en gros on l'initialize).
	def self.first(data)
		Block.new(0, data, "0")#(index, data, hash)
	end

#Deuxième block (et tout ceux qui viennent après).
	def self.next(previous, data=gets)#previous vas stocker block entier précédent et data=gets permet de rentrer de la data dans le shell, mais en prod on a une variable (users, reservations, ...)
		Block.new(previous.index+1, data, previous.hash) #previous.hash = permet que c'est infalsifiable.
	end

end

#2 méthode qui doivent être dans un autre fichier !!!
def create_first_block
	i = 0
	instance_variable_set("@b#{i}", Block.first("THP"))#instance_variable_set = passer d'un string à une variable d'instance pour rendre ça dynamic.
	LEDGER << @b0
	pp @b0
	add_block
end

def add_block
#loop qui créer le tout premier block
	i = 1
	loop do
		instance_variable_set("@b#{i}", Block.next(instance_variable_get("@b#{i-1}"))) #instance_variable_get = récupère le nom de la variable
		LEDGER << instance_variable_get("@b#{i}")
		puts "=============================="
		pp instance_variable_get("@b#{i}")
		puts "=============================="
		i += 1
	end
end

create_first_block