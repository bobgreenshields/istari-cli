require_relative 'roster_item'

module Istari
	class RosterError < StandardError
	end

	class Roster

		def self.from_array(items_array)
			self.new.tap do |roster|
				roster.load_from_array(items_array)
			end
		end

		def initialize
			@items_array = []
			@items_hash = {}
			@dirty = false
		end

		def count
			@items_array.length
		end

		def has_mob?(mob_id)
			@items_hash.has_key?(mob_id.strip.downcase)
		end

		def each
			return enum_for(:each) unless block_given?
			@items_array.each { |item| yield(item) }
		end

		def unplaced_mobs(mobs)
			return enum_for(:unplaced_mobs, mobs) unless block_given?
			mobs.each { |mob| yield mob unless has_mob?(mob.id) }
		end

		def load_from_array(items_array)
			items_array.each do |item_hash|
				item = RosterItem.from_hash(item_hash)
				simple_push(item)
			end
			sort
			self
		end

		def push(item)
			if has_mob?(item.mob_id)
				raise RosterError, "An item with a mob of #{item.mob_id} already exists"
			end
			simple_push(item)
			@dirty = true
			sort
			self
		end

		def save(saver)
			saver.call(self) if @dirty
		end

		private

		def simple_push(item)
			@items_array.push(item)
			@items_hash[item.mob_id] = item
			self
		end

		def sort
			@items_array = @items_array.sort
		end
	end
end
