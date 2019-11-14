class RosterItemError < StandardError
end

class RosterItem
	attr_reader :area, :mob, :mob_id, :notes	

	def self.valid_area?(value)
		return true if value.is_a? Integer
		return false unless value.is_a? String
		value.strip.match(/^[+-]?\d+$/)
	end

	def self.from_hash(item_hash)
		%w(area mob).each do |key|
			unless item_hash.has_key?(key)
				raise RosterItemError, "RosterItem build hash missing a key of #{key}"
			end
		end
		item = self.new
		item.area = item_hash["area"]
		item.mob = item_hash["mob"]
		item.notes = item_hash.fetch("notes", "")
		item
	end

	def initialize
		@area = 0
	end

	def area=(value)
		unless self.class.valid_area?(value)
			raise RosterItemError, "Area must be an integer or string integer not: #{value}"
		end
		@area = value.to_i
	end

	def mob=(value)
		@mob = value.strip
		@mob_id = @mob.downcase
	end

	def notes=(value)
		@notes = value.strip
	end

end
