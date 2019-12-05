require 'yaml'
require 'pathname'
require_relative 'area'
require_relative 'areas'

module Istari
	class AreasYamlLoaderError < StandardError
	end

	class AreasYamlLoader
		def initialize(area_dir: , area_items_dir:)
			@dir_path = Pathname.new(area_dir)
			@items_dir_path = Pathname.new(area_items_dir)
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
					areas_array.push(area_hash)
				end
			end
			Areas.from_array(areas_array)
		end

		def items
			@items ||= load_items
		end

		def load_items
			@items ||= {}
			file_match = /(?<area_no>\d+)\.yml/
			@items_dir_path.each_child do |child|
				next unless matches = file_match.match(child.basename.to_s)
				child_hash = YAML.load(child.read)
				@items[matches[:area_no].to_i] = YAML.load(child.read)
			end
			@items
		end
	end
	
end
