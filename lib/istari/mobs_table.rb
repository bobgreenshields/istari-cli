require_relative 'mobs'
require 'tabulo'

class MobsTable
	def initialize(table_width)
		@table_width = table_width
	end

	def call(mobs)
		Tabulo::Table.new(mobs.each, :id, :desc, :pp, :loot).pack(max_table_width: @table_width).to_s
	end
end

