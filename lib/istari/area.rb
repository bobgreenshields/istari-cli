module Istari
	class Area
		attr_reader :number, :title, :description

		def initialize(number)
			@number = number.to_i
			@player_images = []
			@leads_to = []
		end

		def title=(value)
			@title = value.strip
		end

		def description=(value)
			@description = value.strip
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

		def self.from_hash(values)
			self.new(values["number"]).tap do |area|
				area.title = values.fetch("title", "")
				area.description = values.fetch("description", "")
				area.player_images = values.fetch("player_images", [])
				area.leads_to = values.fetch("leads_to", [])
			end
		end
		
	end
end
