require_relative 'rules'
require 'tabulo'

module Istari
	class RulesTable
		def initialize(table_width)
			@table_width = table_width
		end

		def call(rules)
			Tabulo::Table.new(rules.each) do |t|
				t.add_column("Title", &:title)
				t.add_column("Summary", &:summary)
			end.pack(max_table_width: @table_width).to_s
		end
	end
end
