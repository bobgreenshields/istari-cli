module Istari
	class Rule
		attr_reader :title, :summary, :title_link

		def initialize(title)
			@title = title.strip.gsub('"',"'")
			@summary = ""
			@title_link = ""
		end

		def summary=(value)
			@summary = value.strip.gsub('"',"'")
		end

		def title_link?
			@title_link.length > 0
		end

		def title_link=(value)
			@title_link = value.strip.gsub('"',"'")
		end

		def <=>(other)
			@title <=> other.title
		end

		def self.from_hash(rule_hash)
			self.new(rule_hash["title"]).tap do |rule|
				rule.summary = rule_hash.fetch("summary", "")
				rule.title_link = rule_hash.fetch("title_link", "")
			end
		end
	end
	
end
