require_relative 'area'
require 'tabulo'

module Istari
	class ItemsTable
		def initialize(table_width)
			@table_width = table_width
		end

		def call(area)
			Tabulo::Table.new(area.items) do |t|
				t.add_column("Title", &:title)
				t.add_column("Description") { |item| trim_desc(item.description) }
			end.pack(max_table_width: @table_width).to_s
		end

		def trim_desc(desc)
			desc.length > @table_width - 50 ? desc[0..@table_width - 53] + "..." : desc
		end
	end
end
