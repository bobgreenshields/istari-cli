class RosterItemError < StandardError
end

class RosterItem
	attr_accessor :notes	
	attr_reader :mob, :mob_id

	def initialize
		@area = 0
	end

	def area=(value)
		if value.is_a? String
			value = value.strip
			unless value.match(/^[+-]?\d+$/)
				raise RosterItemError, "Area must be an integer or string integer not: #{value}"
			end
		end
			@area = value.to_i
	end

	def area
		@area.to_s
	end

end
