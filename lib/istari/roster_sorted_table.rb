require_relative 'areas'
require 'tabulo'

module Istari
	class RosterSortedTable
		def initialize(table_width)
			@table_width = table_width
		end

		def call(roster:, mobs:, areas:)
			Tabulo::Table.new(roster.each) do |t|
				t.add_column("No.", &:area)
				t.add_column("Area") do |item|
					areas.has_number?(item.area) ? areas[item.area].title : ""
				end
				t.add_column("Mob id", &:mob)
				t.add_column("Mob") do |item|
					mobs.has_id?(item.mob_id) ? trim_mob(mobs[item.mob_id].desc) : ""
				end
				t.add_column("Notes") { |item| trim_notes(item.notes) }
			end.pack(max_table_width: @table_width).to_s
		end

		def trim_notes(desc)
			desc.length > 40 ? desc[0..37] + "..." : desc
		end

		def trim_mob(desc)
			desc.length > 25 ? desc[0..22] + "..." : desc
		end
	end
end
