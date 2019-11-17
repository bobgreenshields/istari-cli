require 'yaml'
require 'pathname'
require_relative 'mobs'

class MobsYamlLoaderError < StandardError
end

class MobsYamlLoader
	def initialize(file_path)
		@file_path = Pathname.new(file_path)
	end

	def call
		unless @file_path.exist?
			raise	MobsYamlLoaderError, "Trying to load some mobs but #{@file_path} does not exist"
		end
		Mobs.from_hash(YAML.load(@file_path.read))
	end
end
