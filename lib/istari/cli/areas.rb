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
				list
				Istari.areas_save(areas)
			end
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

			desc "list", "list all areas"
			def list
				puts Istari.areas_table.call(areas)
			end

			private

			# def prompt_for_id
			# 	puts "The next available generic id is: #{mobs.next_id}"
			# 	puts "To use generic id press return"
			# 	puts ""
			# 	id = ask("Enter id (. to exit) id?").strip.downcase
			# 	exit if id == "."
			# 	return mobs.next_id if id == ""
			# 	confirm_id(id)
			# end

			# def confirm_id(id)
			# 	id = id.strip.downcase.gsub(/\s+/, '-').gsub(/[^a-z0-9\-]/i, '')
			# 	return id unless mobs.has_id?(id)
			# 	puts set_color("This id: #{id} is already in use please enter a different one", :red)
			# 	prompt_for_id
			# end
			
			def areas
				@areas || refresh_areas
			end

			def refresh_areas
				@areas = Istari.areas_get
			end
		end
		
	end
end
