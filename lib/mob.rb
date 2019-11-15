class Mob
	attr_reader :pp, :id, :loot, :desc
	def initialize(id)
		@id = id.downcase
		@pp = ""
		@loot = ""
		@desc = ""
	end

	def pp=(value)
		@pp = value.to_i.to_s
	end

	def <=>(other)
		@id <=> other.id
	end

	def loot=(value)
		@loot = value.strip
	end

	def desc=(value)
		@desc = value.strip
	end

	def self.from_hash(id, values)
		self.new(id).tap do |mob|
			mob.pp = values["pp"]
			mob.loot = values["loot"]
			mob.desc = values["desc"]
		end
	end
end
