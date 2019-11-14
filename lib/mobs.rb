require_relative 'mob'

class MobsError < StandardError
end

class Mobs

	def self.from_hash(mobs_hash)
		mobs = self.new
		mobs.load_from_hash(mobs_hash)
		mobs
	end

	def initialize
		@mobs_array = []
		@mobs_hash = {}
	end

	def load_from_hash(mobs_hash)
		mobs_hash.each_pair do |key, value|
			mob = Mob.from_hash(key, value)
			simple_push(mob)
		end
		sort
	end

	def has_id?(id)
		id_to_test = id.downcase
		@mobs_hash.has_key?(id_to_test)
	end

	def push(mob)
		if has_id?(mob.id)
			raise MobsError, "A mob with the id of #{mob.id} already exists"
		end
		simple_push(mob)
		sort
		self
	end

	private

	def simple_push(mob)
		@mobs_array.push(mob)
		@mobs_hash[mob.id] = mob
		self
	end

	def sort
		@mobs_array = @mobs_array.sort
	end
	
end
