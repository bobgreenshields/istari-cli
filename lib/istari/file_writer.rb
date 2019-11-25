require 'pathname'

module Istari
	class FileWriter
		def initialize(backup = -> {})
			@backup = backup
		end

		def call(file:, content:)
			@file_path = Pathname.new(file)
			@backup.call(@file_path)
			terminator = content[-1] == "\n" ? "" : "\n"
			@file_path.write(content + terminator)
		end
	end
end
