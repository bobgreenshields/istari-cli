module Istari
	class AreasError < StandardError
	end

	class Areas
		def initialize
			@areas_array = []
			@areas_hash = {}
		end

		def count
			@areas_array.length
		end

		def has_number?(number)
			@areas_hash.has_key?(number)
		end

		def push(area)
			if has_number?(area.number)
				raise AreasError, "An area with the number of #{area.number} already exists"
			end
			@areas_array.push(area)
			@areas_hash[area.number] = area
			sort
			self
		end

		private

		def sort
			@areas_array = @areas_array.sort
		end
		
	end
	

end
