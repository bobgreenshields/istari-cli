class Mob
	attr_accessor :loot, :desc
	attr_reader :pp, :id
	def initialize(id)
		@id = id
	end

	def pp=(value)
		@pp = value.to_i.to_s
	end

	def <=>(other)
		@id <=> other.id
	end

	def self.from_hash(id, values)
		mob = self.new(id)
		mob.pp = values["pp"]
		mob.loot = values["loot"]
		mob.desc = values["desc"]
		mob
	end
end
