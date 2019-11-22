require 'thor'
require_relative '../../istari'

module Istari
	module Cli
		class Mobs < Thor
			desc "add", "add a new mob"
			def add
				puts "The next available generic id is: #{mobs.next_id}"
				puts "To use generic id simply press return"
				puts ""
				id = ask("Enter id (. to exit) id?").strip.downcase
				id = mobs.next_id if id == ""
				exit if id == "."
				while mobs.has_id?(id)
					puts set_color("This id: #{id} is already in use please enter a different one", :red)
					id = ask("Enter id (. to exit) id?").strip.downcase
					exit if id == "."
				end
				puts set_color("Using id: #{id}", :green)
			end

			desc "list", "list all current mobs"
			def list
				puts Istari.mobs_table.call(mobs)
			end

			private
			
			def mobs
				@mobs || refresh_mobs
			end

			def refresh_mobs
				@mobs = Istari.mobs_get
			end
		end
		
	end
end
