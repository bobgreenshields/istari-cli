require 'thor'
require_relative '../../istari'

module Istari
	module Cli
		class Areas < Thor
			option :number, aliases: '-n', desc: "The number to use for the area"
			option :single, aliases: '-s', type: :boolean, desc: "Do not ask for multiple areas"
			
			desc "add", "add a new area"
			def add
				if options.key?(:number)
					number = number_from_options
				else
					number = prompt_for_number
				end
				say "Using number: #{number}", :green
				title = ask("Enter the title of the area: ")
				desc = ask("Enter a description of the area: ")
				leads_to = []
				adjoining = 1
				while adjoining != ""
					adjoining = ask("Enter the number of an adjoining area (return for none): ").strip
					leads_to << adjoining.to_i if /[+-]?\d+/.match(adjoining)
					puts leads_to.inspect
				end
				area = Istari::Area.new(number)
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
				yn = ask("Add another area? [y/N]").strip.downcase
				return if options[:single]
				if yn == "y"
					options.delete(:number)
					add
				end
			end

			desc "list", "list all areas"
			def list
				puts Istari.areas_table.call(areas)
			end

			private

			def prompt_for_number
				say("Just press enter to use next available number of #{areas.next_number}")
				number = ask("Enter a number (. to exit)").strip
				# matches a dot, the empty string and an integer
				unless /^(\.|[+-]?\d*)$/.match(number)
					say("#{number} is not empty, a number or .  Please start again", :red)
					exit
				end
				
				case number
				when "."
					exit
				when ""
					number = areas.next_number
				when ->(number_to_check){ areas.has_number?(number_to_check.to_i) }
					say("Number: #{number} has already been used.  Try again", :red)
					prompt_for_number
				else
						number.to_i
				end
			end

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

			def number_from_options
				unless options[:number].match(/[+-]?\d+/)
					say("Areas add command was passed a value of:  #{options[:number]} which is not a number.", :red)
					exit
				end
				number = options[:number].to_i
				return number unless areas.has_number?(number)
				say("Areas add command was passed an area number: #{number} that has already been used", :red)
				exit
			end
		end
		
	end
end
