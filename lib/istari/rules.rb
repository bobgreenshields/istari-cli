require_relative 'area'

module Istari
	class AreasError < StandardError
	end

	class Areas

		def self.from_array(areas_array)
			self.new.tap do |areas|
				areas.load_from_array(areas_array)
			end
		end
		
		def initialize
			@areas_array = []
			@areas_hash = {}
			@new_areas = []
		end

		def count
			@areas_array.length
		end

		def has_number?(number)
			@areas_hash.has_key?(number.to_i)
		end

		def [](number)
			@areas_hash[number.to_i]
		end

		def each
			return enum_for(:each) unless block_given?
			@areas_array.each { |area| yield(area) }
		end

		def next_number
			result = 1
			while has_number?(result)
				result = result.next
			end
			result
		end

		def load_from_array(areas_array)
			areas_array.each do |area_hash|
				area = Area.from_hash(area_hash)
				simple_push(area)
			end
			sort
			self
		end

		def push(area)
			if has_number?(area.number)
				raise AreasError, "An area with the number of #{area.number} already exists"
			end
			simple_push(area)
			@new_areas.push(area)
			sort
			self
		end

		def save(saver)
			@new_areas.each { |area| saver.call(area) }
		end

		private

		def simple_push(area)
			@areas_array.push(area)
			@areas_hash[area.number] = area
			self
		end

		def sort
			@areas_array = @areas_array.sort
		end
		
	end
	

end
