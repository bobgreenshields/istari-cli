require_relative 'roster'
require 'tabulo'

module Istari
	class RosterTable
		def initialize(table_width)
			@table_width = table_width
		end

		def call(roster)
			Tabulo::Table.new(roster.each, :mob, :area, :notes).pack(max_table_width: @table_width).to_s
		end
	end
end
