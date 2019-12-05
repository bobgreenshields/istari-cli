require_relative 'areas'
require 'tabulo'

module Istari
	class AreasTable
		def initialize(table_width)
			@table_width = table_width
		end

		def call(areas)
			Tabulo::Table.new(areas.each) do |t|
				t.add_column("Number", &:number)
				t.add_column("Title", &:title)
				t.add_column("Description") { |area| trim_desc(area.description) }
				t.add_column("Leads to") { |area| area.leads_to.map(&:to_s).join(',') }
				t.add_column("Items") { |area| area.item_count.to_s }
			end.pack(max_table_width: @table_width).to_s
		end

		def trim_desc(desc)
			desc.length > 40 ? desc[0..37] + "..." : desc
		end
	end
end
