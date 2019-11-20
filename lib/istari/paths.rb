require 'pathname'

module Istari
	class Paths
		attr_reader :istari_root
		def initialize
			curr_dir = Pathname.pwd
			until (curr_dir + "Gemfile").exist?
				raise StandardError if curr_dir.root?
				curr_dir = curr_dir.parent
			end
			@istari_root = curr_dir
		end
	end
	
end
