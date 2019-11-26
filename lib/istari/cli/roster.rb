require 'thor'
require_relative '../../istari'
require_relative 'mobs'

module Istari
	module Cli
		class Roster < Thor
			option :mob
			option :area
			option :single, aliases: '-s', type: :boolean, desc: "Do not ask for multiple roster items"
			
			desc "add", "place a mob in an area on the roster"
			def add
				mob = prompt_for_mob
				area = prompt_for_area


			# 	id = options[:id] || prompt_for_id
			# 	id = confirm_id(id)
			# 	puts set_color("Using id: #{id}\n", :green)
			# 	desc = ask("Enter a description:").strip.gsub('"', "'")
			# 	puts set_color("Using desc: #{desc}\n", :green)
			# 	loot = ask("Enter loot:").strip.gsub('"', "'")
			# 	puts set_color("Using loot: #{loot}\n", :green)
			# 	pp = ask("Enter passive perception:").strip.gsub(/[^0-9]/, '')
			# 	puts set_color("Using passive perception: #{pp}\n", :green)
			# 	mob = Istari::Mob.new(id)
			# 	mob.desc = desc if desc.length > 0
			# 	mob.loot = loot if loot.length > 0
			# 	mob.pp = pp if pp.length > 0
			# 	mobs.push(mob)
			# 	list
			# 	return if options[:single]
			# 	again = ask("Add another mob [y/N]?").strip.downcase
			# 	return unless again == "y"
			# 	options.delete(:id)
			# 	add
			end

			desc "list", "list all current roster placements"
			def list
				puts Istari.roster_table.call(roster)
			end

			private

			def prompt_for_mob
				say "Choose a mob to place (. to exit)"
				response = ask "list / enter / add", limited_to: ['l', 'e', 'a', '.']
				if response.downcase[0] == 'l'
					list_mobs
				end
				exit if response == "."
				if response.downcase[0] == 'a'
					mob = add_mob
				else
					mob = ask("Enter the mob id: ").strip
				end
				exit if mob == "."
				if roster.unplaced_mobs(mobs).select { |unpl_mob| unpl_mob.id == mob.downcase }.empty?
				# unless mobs.has_id?(mob.downcase)
					say "could not find a mob with the id of: #{mob.downcase}, try again", :red
					prompt_for_mob
				end
				say "Using mob: #{mob}", :green
				mob
			end

			def prompt_for_area
				say "Choose an area for the mob (. to exit)"
				# response = ask "list / enter / add", limited_to: ['l', 'e', 'a', '.']
				response = ask "list / enter ", limited_to: ['l', 'e', '.']
				if response.downcase[0] == 'l'
					list_areas
				end
				exit if response == "."
				# if response.downcase[0] == 'a'
				# 	mob = add_mob
				# else
					 area = ask("Enter the area number: ").strip
				# end
				exit if area == "."
				say "Using area: #{area}", :green
				unless areas.has_number?(area.to_i)
					say "could not find a area with a number of: #{area}, try again", :red
					prompt_for_area
				end
				area
			end

			

			# def confirm_id(id)
			# 	id = id.strip.downcase.gsub(/\s+/, '-').gsub(/[^a-z0-9\-]/i, '')
			# 	return id unless mobs.has_id?(id)
			# 	puts set_color("This id: #{id} is already in use please enter a different one", :red)
			# 	prompt_for_id
			# end
			
			def add_mob
				mobs_cli = Istari::Cli::Mobs.new
				mobs_cli.options = { single: true }
				mob_id = mobs_cli.add
				refresh_mobs
				list_mobs
				mob_id
			end
			
			def list_mobs
				# puts Istari.mobs_table.call(mobs)
				puts Istari.mobs_table.call(roster.unplaced_mobs(mobs))
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
