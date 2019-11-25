module Istari
	class RosterItemError < StandardError
	end

	class RosterItem
		attr_reader :area, :mob, :mob_id, :notes	

		def self.missing_keys(item_hash)
			%w(area mob).inject([]) do | missing, key |
				missing << key unless item_hash.has_key?(key)
				missing
			end
		end

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
			item = self.new(item_hash["mob"], item_hash["area"] )
			item.notes = item_hash.fetch("notes", "")
			item
		end

		def initialize(mob, area)
			@mob = mob.strip
			@mob_id = @mob.downcase
			unless self.class.valid_area?(area)
				raise RosterItemError, "Area must be an integer or string integer not: #{area}"
			end
			@area = area.to_i
		end

		def notes=(value)
			@notes = value.strip
		end

		def <=>(other)
			@mob_id <=> other.mob_id
		end

	end
end
