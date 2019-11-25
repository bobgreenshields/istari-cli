require_relative 'istari/mob'
require_relative 'istari/mobs'
require_relative 'istari/mobs_yaml_loader'
require_relative 'istari/mobs_table'
require_relative 'istari/areas_yaml_loader'
require_relative 'istari/areas_table'
require_relative 'istari/roster_yaml_loader'
require_relative 'istari/roster_table'
require 'pathname'
require 'dry/container'

module Istari
	extend Dry::Container::Mixin

	register(:search_root) { Pathname.pwd }
	register(:table_width) { 120 }
	register(:backup_dir_name) { ".backups" }
	register(:mobs_loader) { MobsYamlLoader.new(self.mobs_file) }
	register(:mobs_table) { MobsTable.new(self[:table_width]) }
	register(:areas_loader) { AreasYamlLoader.new(self.areas_dir) }
	register(:areas_table) { AreasTable.new(self[:table_width]) }
	register(:roster_loader) { RosterYamlLoader.new(self.roster_file) }
	register(:roster_table) { RosterTable.new(self[:table_width]) }

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

		def areas_dir
			istari_root + "_areas"
		end

		def roster_file
			istari_root + "_data" + "01-default.yml"
		end

		def mobs_get
			self[:mobs_loader].call
		end

		def mobs_table
			self[:mobs_table]
		end

		def areas_get
			self[:areas_loader].call
		end

		def areas_table
			self[:areas_table]
		end

		def roster_get
			self[:roster_loader].call
		end

		def roster_table
			self[:roster_table]
		end

		def mob_create(id)
			Mob.new(id)
		end

		def backup_dir
			dir = istari_root + self[:backup_dir_name]
			dir.mkdir unless dir.exist?
			dir
		end
		
	end
	
end
