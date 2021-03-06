module Istari
	class Mob
		attr_reader :pp, :id, :loot, :desc
		def initialize(id)
			@id = id.strip.downcase
			@pp = ""
			@loot = ""
			@desc = ""
		end

		def pp=(value)
			@pp = value.to_i.to_s.gsub('"',"'")
		end

		def <=>(other)
			@id <=> other.id.gsub('"',"'")
		end

		def loot=(value)
			@loot = value.strip.gsub('"',"'")
		end

		def desc=(value)
			@desc = value.strip.gsub('"',"'")
		end

		def self.from_hash(id, values)
			self.new(id).tap do |mob|
				mob.pp = values.fetch("pp", "")
				mob.loot = values.fetch("loot", "")
				mob.desc = values.fetch("desc", "")
			end
		end
	end
	
end
