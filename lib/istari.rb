require_relative 'istari/mob'
require_relative 'istari/mobs'
require_relative 'istari/mobs_yaml_loader'
require_relative 'istari/mobs_table'
require 'pathname'
require 'dry/container'

module Istari
	extend Dry::Container::Mixin

	register(:search_root) { Pathname.pwd }
	register(:mobs_loader) { MobsYamlLoader.new(self.mobs_file) }
	register(:table_width) { 120 }
	register(:mobs_table) { MobsTable.new(self[:table_width]) }

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

		def mobs_file
			istari_root + "_data" + "mobs.yml"
		end

		def mobs_get
			self[:mobs_loader].call
		end

		def mobs_table
			self[:mobs_table]
		end

		def mob_create(id)
			Mob.new(id)
		end
		
	end
	
end
