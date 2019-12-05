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
			areas_array = []
			@dir_path.each_child do |child|
				if child.extname == ".md"
					area_hash = YAML.load(child.read)
					area_number = area_hash["number"].to_i
					if items.key?(area_number)
						area_hash["items"] = items[area_number]
					end
					areas_array.push(YAML.load(child.read))
				end
			end
			Areas.from_array(areas_array)
		end

		def items
			@items ||= load_items(items_dir_path)
		end

		def load_items(items_dir_path)
			@items ||= {}
			file_match = /(?<area_no>\d+)\.yml/
			@dir_path.each_child do |child|
				next unless matches = file_match.match(child.basename)
				@items[matches[:area_no].to_i] = YAML.load(child.read)
			end
		end
	end
	
end
