require 'yaml'
require 'pathname'
require_relative 'roster'

module Istari
	class RosterYamlLoaderError < StandardError
	end

	class RosterYamlLoader
		def initialize(file_path)
			@file_path = Pathname.new(file_path)
		end

		def call
			unless @file_path.exist?
				raise	RosterYamlLoaderError, "Trying to load a roster but #{@file_path} does not exist"
			end
			Roster.from_array(YAML.load(@file_path.read))
		end
	end
	
end
