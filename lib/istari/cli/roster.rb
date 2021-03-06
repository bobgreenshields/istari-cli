require 'thor'
require_relative '../../istari'
require_relative 'mobs'

module Istari
	module Cli
		class Roster < Thor
			option :area
			option :single, aliases: '-s', type: :boolean, desc: "Do not ask for multiple roster items"
			
			desc "add", "place a mob in an area on the roster"
			def add
				# puts "Options array is"
				# puts options.inspect
				mob = prompt_for_mob
				if options.has_key?(:area)
					area = area_from_options
				else
					area = prompt_for_area
				end
				say("Placing mob: #{mob} (#{mobs[mob].desc}) in area: #{area} #{areas[area].title}", :green)
				roster_item = Istari::RosterItem.new(mob, area)
				roster_item.notes = ask("Add any notes for this mob: ")
				roster.push(roster_item)
				if options[:single]
					Istari.roster_save(roster)
					return
				end
				again = ask("Add another mob [y/N]?").strip.downcase
				if again == "y"
					options.delete("area")
					add
				end
				Istari.roster_save(roster)
			end

			desc "list", "list all current roster placements"
			def list
				puts Istari.roster_table.call(roster)
			end

			desc "byarea", "list roster items by area"
			def byarea
				sorted_roster = roster.each.sort do |a,b|
					result = a.area <=> b.area
					result == 0 ? a.mob_id <=> b.mob_id : result
				end
				puts Istari.roster_sorted_table.call(roster: sorted_roster, mobs: mobs, areas: areas)
			end

			private

			def area_from_options
				return options[:area].to_i if valid_area?(options[:area])
				say("Roster add command was passed an invalid area option of: #{options[:area]}", :red)
				exit
			end

			def valid_unplaced_mob?(mob_str)
				mobs.has_id?(mob_str) && (! roster.has_mob?(mob_str))
			end

			def prompt_for_mob
				list_mobs
				# say("The next available generic id for a mob is #{mobs.next_id}")
				say("Just press enter to use next generic mob id of #{mobs.next_id}")
				id = ask("Choose a mob or add a new one (. to exit)").strip
				# id = id == '' ? mobs.next_id : id
				case id
				when "."
					exit
				when ""
					id = add_mob(mobs.next_id)
				when ->(id){ mobs.has_id?(id) }
					if roster.has_mob?(id)
						say("Mob: #{id} has already been placed.  Try again", :red)
						prompt_for_mob
					else
						say "Using mob: #{id}", :green
						id
					end
				else
					yn = ask("No mob with the id of: #{id} exists, would you like to make it [y/N]?").strip.downcase
					if yn == "y"
						id = add_mob(id)
						say "Using mob: #{id}", :green
						id
					else
						prompt_for_mob
					end
				end
			end

			def valid_area?(area_str)
				return false unless Istari::Area.area_number_good?(area_str)
				areas.each.any? { |area| area.number == area_str.to_i }
			end

			def prompt_for_area
				list_areas
				area = ask "Choose an area for the mob (. to exit)".strip
				case area
				when /\./
					exit
				when /[+-]?\d+/
					if valid_area?(area)
						area.to_i
						area
					else
						say("Could not find an area with a number of: #{area} try again", :red)
						prompt_for_area
					end
				else
					say("Invalid input.  Try again", :red)
					prompt_for_area
				end
			end
			
			def add_mob(id)
				mobs_cli = Istari::Cli::Mobs.new
				mobs_cli.options = { id: id, single: true, nolist: true }
				mob_id = mobs_cli.add
				refresh_mobs
				mob_id
			end
			
			def list_mobs
				if roster.unplaced_mobs(mobs).count == 0
					say "There are no unplaced mobs available for placing"
				else
					say "The mobs available for placing are"
					puts Istari.mobs_table.call(roster.unplaced_mobs(mobs))
				end
			end
			
			def list_areas
				puts Istari.areas_table.call(areas)
			end
			
			def roster
				@roster || refresh_roster
			end

			def refresh_roster
				@roster = Istari.roster_get
			end
			
			def mobs
				@mobs || refresh_mobs
			end

			def refresh_mobs
				@mobs = Istari.mobs_get
			end
			
			def areas
				@areas || refresh_areas
			end

			def refresh_areas
				@areas = Istari.areas_get
			end
		end
		
	end
end
