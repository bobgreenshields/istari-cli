require 'thor'
require_relative './cli/mobs'
require_relative './cli/areas'

module Istari
	module Cli
		class App < Thor
			desc "mobs SUBCOMMAND ...ARGS", "create and manage the encounter's mobs"	
			subcommand "mobs", Istari::Cli::Mobs

			desc "areas SUBCOMMAND ...ARGS", "create and manage the encounter's areas"	
			subcommand "areas", Istari::Cli::Areas
		end
	end
	
end
