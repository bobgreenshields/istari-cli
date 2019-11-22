require 'yaml'
require 'pathname'
require_relative 'area'
require_relative 'areas'

module Istari
	class AreasYamlLoaderError < StandardError
	end

	class AreasYamlLoader
		def initialize(dir_path)
			@dir_path = Pathname.new(dir_path)
		end

		def call
			unless @dir_path.exist?
				raise	AreasYamlLoaderError, "Trying to load some areas but #{@dir_path} does not exist"
			end
			areas = Areas.new
			@dir_path.each_child do |child|
				if child.extname == ".md"
					areas.push(Area.from_hash(YAML.load(child.read)))
				end
			end
			areas
		end
	end
	
end
