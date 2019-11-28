module Istari
	class Area
		attr_reader :number, :title, :description

		def initialize(number)
			@number = number.to_i
			@player_images = []
			@leads_to = []
		end

		def <=>(other)
			@number <=> other.number
		end

		def title=(value)
			@title = value.strip.gsub('"',"'")
		end

		def description=(value)
			@description = value.strip.gsub('"',"'")
		end

		def player_images=(value)
			@player_images = Array(value).map { |image| image.strip }
		end

		def leads_to=(value)
			@leads_to = Array(value).map { |area| area.to_i }
		end

		def player_images
			return enum_for(:player_images) unless block_given?
			@player_images.each { |image| yield(image) }
		end

		def leads_to
			return enum_for(:leads_to) unless block_given?
			@leads_to.each { |area| yield(area) }
		end

		def self.from_hash(area_hash)
			self.new(area_hash["number"]).tap do |area|
				area.title = area_hash.fetch("title", "")
				area.description = area_hash.fetch("description", "")
				area.player_images = area_hash.fetch("player_images", [])
				area.leads_to = area_hash.fetch("leads_to", [])
			end
		end

		def self.area_number_good?(area_number)
			return true if area_number.is_a? Integer
			return false unless area_number.is_a? String
			/^[+-]?\d+$/.match(area_number.strip) ? true : false
		end
		
	end
end
