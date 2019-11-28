require_relative 'istari/mob'
require_relative 'istari/mobs'
require_relative 'istari/mobs_yaml_loader'
require_relative 'istari/mobs_yaml'
require_relative 'istari/mobs_table'
require_relative 'istari/areas_yaml_loader'
require_relative 'istari/area_yaml'
require_relative 'istari/areas_table'
require_relative 'istari/roster_yaml_loader'
require_relative 'istari/roster_table'
require_relative 'istari/roster_sorted_table'
require_relative 'istari/file_writer'
require_relative 'istari/backup_time'

require 'pathname'
require 'dry/container'

module Istari
	extend Dry::Container::Mixin

	register(:search_root) { Pathname.pwd }
	register(:table_width) { 120 }
	register(:backup_dir_name) { ".backups" }
	register(:backup) { BackupTime.new(self[:backup_dir_name]) }
	register(:writer) { FileWriter.new(self[:backup]) }

	register(:mobs_loader) { MobsYamlLoader.new(self.mobs_file) }
	register(:mobs_table) { MobsTable.new(self[:table_width]) }
	register(:mobs_saver) { MobsYaml }

	register(:areas_loader) { AreasYamlLoader.new(self.areas_dir) }
	register(:areas_table) { AreasTable.new(self[:table_width]) }
	register(:areas_saver) { AreaYaml }

	register(:roster_loader) { RosterYamlLoader.new(self.roster_file) }
	register(:roster_table) { RosterTable.new(self[:table_width]) }
	register(:roster_sorted_table) { RosterSortedTable.new(self[:table_width]) }

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

		def mobs_save(mobs)
			saver = self[:mobs_saver].new(mobs_file: mobs_file, writer: self[:writer])
			mobs.save(saver)
		end

		def mobs_table
			self[:mobs_table]
		end

		def areas_get
			self[:areas_loader].call
		end

		def areas_save(areas)
			saver = self[:areas_saver].new(areas_dir: areas_dir, writer: self[:writer])
			areas.save(saver)
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

		def roster_sorted_table
			self[:roster_sorted_table]
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
