require 'thor'

module Istari
	module Cli
		class Mobs < Thor
			desc "add", "add a new mob"
			def add
				puts "adding a mob"
			end
		end
		
	end
end
