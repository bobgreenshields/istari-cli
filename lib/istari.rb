require_relative 'istari/mob'
require 'pathname'
require 'dry/container'

module Istari
	extend Dry::Container::Mixin

	register(:search_root) { Pathname.pwd }

	class << self
		def istari_root
			@istari_root ||= find_istari_root
		end

		def find_istari_root
			curr_dir = self.resolve(:search_root)
			until (curr_dir + ".istarirc").exist?
				if curr_dir.root?
					raise StandardError, "Please run this in an Istari directory" 
				end
				curr_dir = curr_dir.parent
			end
			curr_dir
		end
		
	end
	
end
