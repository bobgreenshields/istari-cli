require 'thor'
require_relative '../../istari'

module Istari
	module Cli
		class Items < Thor
			desc "list AREA_NUMBER", "list area items for area with number AREA_NUMBER"
			def list(area_number)
				check_area(area_number)
				area = areas[area_number]
				if area.items?
					puts
					say "                 *** #{area.number} #{area.title} ***"
					puts Istari.items_table.call(area)
				else
					say "Area #{area.number} #{area.title} has no items"
				end
			end

			desc "add AREA_NUMBER", "add an item to area with number AREA_NUMBER"
			def add(area_number)
				check_area(area_number)
				area = areas[area_number]
				again = 'y'
				while again == 'y'
					title = ask("Enter a title:").strip.gsub('"', "'")
					desc = ask("Enter a description:").strip.gsub('"', "'")
					area.add_item(title: title, description: desc)
					again = ask("Add another item [y/N]?").strip.downcase
				end
				Istari.items_save(area)
				area_number
			end

			private

			def check_area(area_number)
				if ! area_number.kind_of?(Integer) && ! /\d+/.match(area_number)
					say "#{area_number} is not a number, please use digits for the area number", :red
					exit
				end
				if ! areas.has_number?(area_number)
					say "There is no area with a number of #{area_number}", :red
					say "Try listing the areas with: istari areas list"
					exit
				end
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

