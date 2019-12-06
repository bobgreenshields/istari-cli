require_relative 'rule'

module Istari
	class RulesError < StandardError
	end

	class Rules

		def self.from_array(rules_array)
			self.new.tap do |rules|
				rules.load_from_array(rules_array)
			end
		end
		
		def initialize
			@rules_array = []
			@rules_hash = {}
			@new_rules = []
		end

		def count
			@rules_array.length
		end

		def has_title?(title)
			@rules_hash.has_key?(title)
		end

		def [](title)
			@rules_hash[title]
		end

		def each
			return enum_for(:each) unless block_given?
			@rules_array.each { |rule| yield(rule) }
		end

		def load_from_array(rules_array)
			rules_array.each do |rule_hash|
				rule = Rule.from_hash(rule_hash)
				simple_push(rule)
			end
			sort
			self
		end

		def push(rule)
			if has_title?(rule.title)
				raise RulesError, "An rule with the title of #{rule.title} already exists"
			end
			simple_push(rule)
			@new_rules.push(rule)
			sort
			self
		end

		def save(saver)
			@new_rules.each { |rule| saver.call(rule) }
		end

		private

		def simple_push(rule)
			@rules_array.push(rule)
			@rules_hash[rule.title] = rule
			self
		end

		def sort
			@rules_array = @rules_array.sort
		end
		
	end
	

end
