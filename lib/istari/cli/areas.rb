require 'thor'
require_relative '../../istari'

module Istari
	module Cli
		class Areas < Thor
			option :number, aliases: '-n'
			option :single, aliases: '-s', type: :boolean, desc: "Do not ask for multiple mobs"
			
			desc "add", "add a new area"
			def add
				title = ask("Enter the title of the area: ")
				desc = ask("Enter a description of the area: ")
				leads_to = []
				adjoining = 1
				while adjoining != ""
					adjoining = ask("Enter the number of an adjoining area (return for none): ").strip
					leads_to << adjoining.to_i if /[+-]?\d+/.match(adjoining)
					puts leads_to.inspect
				end
				area = Istari::Area.new(areas.next_number)
				area.title = title
				area.description = desc
				area.leads_to = leads_to
				areas.push(area)
				# list
				Istari.areas_save(areas)
				yn = ask("Add an item of interest to this area? [y/N]").strip.downcase
				if yn == "y"
					add_items(area.number)
				end
				yn = ask("Add a mob to this area? [y/N]").strip.downcase
				if yn == "y"
					add_mob(area.number)
				end
			end

			desc "list", "list all areas"
			def list
				puts Istari.areas_table.call(areas)
			end

			private

			def areas
				@areas || refresh_areas
			end

			def refresh_areas
				@areas = Istari.areas_get
			end

			def add_items(area_number)
				items_cli = Istari::Cli::Items.new
				items_cli.add(area_number)
			end

			def add_mob(area_number)
				roster_cli = Istari::Cli::Roster.new
				roster_cli.options = { area: area_number, single: true }
				roster_cli.add
			end
		end
		
	end
end
