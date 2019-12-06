require 'yaml'
require 'pathname'
require_relative 'rule'
require_relative 'rules'

module Istari
	class RulesYamlLoaderError < StandardError
	end

	class RulesYamlLoader
		def initialize(rule_dir:)
			@dir_path = Pathname.new(rule_dir)
		end

		def call
			unless @dir_path.exist?
				raise	RulesYamlLoaderError, "Trying to load some rules but #{@dir_path} does not exist"
			end
			rules_array = []
			@dir_path.each_child do |child|
				rules_array.push(YAML.load(child.read)) if child.extname == ".md"
			end
			Rules.from_array(rules_array)
		end
	
end
