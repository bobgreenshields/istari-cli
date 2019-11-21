require 'thor'
require_relative '../../istari'

module Istari
	module Cli
		class Mobs < Thor
			desc "add", "add a new mob"
			def add
				puts "adding a mob"
			end

			desc "list", "list all current mobs"
			def list
				puts Istari.mobs_table.call(Istari.mobs_get)
			end
		end
		
	end
end
