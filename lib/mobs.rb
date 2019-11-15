require_relative 'mob'

class MobsError < StandardError
end

class Mobs

	def self.from_hash(mobs_hash)
		self.new.tap do |mobs|
			mobs.load_from_hash(mobs_hash)
		end
	end

	def initialize
		@mobs_array = []
		@mobs_hash = {}
	end

	def load_from_hash(mobs_hash)
		mobs_hash.each_pair do |key, value|
			simple_push(Mob.from_hash(key, value))
		end
		sort
	end

	def has_id?(id)
		@mobs_hash.has_key?(id.downcase)
	end

	def push(mob)
		if has_id?(mob.id)
			raise MobsError, "A mob with the id of #{mob.id} already exists"
		end
		simple_push(mob)
		sort
		self
	end

	def each
		return enum_for(:each) unless block_given?
		@mobs_array.each { |mob| yield(mob) }
	end

	def next_id
		result = "a"
		while has_id?(result)
			result = result.next
		end
		result
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
