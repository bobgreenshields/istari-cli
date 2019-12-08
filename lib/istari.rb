require_relative 'istari/mob'
require_relative 'istari/mobs'
require_relative 'istari/mobs_yaml_loader'
require_relative 'istari/mobs_yaml'
require_relative 'istari/mob_page_yaml'
require_relative 'istari/mobs_table'
require_relative 'istari/areas_yaml_loader'
require_relative 'istari/area_yaml'
require_relative 'istari/areas_table'
require_relative 'istari/items_table'
require_relative 'istari/items_yaml'
require_relative 'istari/roster_yaml_loader'
require_relative 'istari/roster_yaml'
require_relative 'istari/roster_table'
require_relative 'istari/roster_sorted_table'
require_relative 'istari/rules_yaml_loader'
require_relative 'istari/rule_yaml'
require_relative 'istari/rules_table'
require_relative 'istari/file_writer'
require_relative 'istari/backup_time'

require 'pathname'
require 'dry/container'

module Istari
	class IstariError < StandardError
	end

	extend Dry::Container::Mixin

	register(:search_root) { Pathname.pwd }
	register(:table_width) { 120 }
	register(:backup_dir_name) { ".backups" }
	register(:backup) { BackupTime.new(self.backup_dir) }
	register(:writer) { FileWriter.new(self[:backup]) }

	register(:mobs_loader) { MobsYamlLoader.new(self.mobs_file) }
	register(:mobs_table) { MobsTable.new(self[:table_width]) }
	register(:mobs_saver) { MobsYaml }
	register(:mob_page_saver) { MobPageYaml }

	register(:areas_loader) { AreasYamlLoader.new(area_dir: self.areas_dir,
																						area_items_dir: self.area_items_dir) }
	register(:areas_table) { AreasTable.new(self[:table_width]) }
	register(:areas_saver) { AreaYaml }
	
	register(:items_table) { ItemsTable.new(self[:table_width]) }
	register(:items_saver) { ItemsYaml }

	register(:rules_loader) { RulesYamlLoader.new(self.rules_dir) }
	register(:rules_table) { RulesTable.new(self[:table_width]) }
	register(:rules_saver) { RuleYaml }

	register(:roster_loader) { RosterYamlLoader.new(self.roster_data_file) }
	register(:roster_table) { RosterTable.new(self[:table_width]) }
	register(:roster_saver) { RosterYaml }
	register(:roster_sorted_table) { RosterSortedTable.new(self[:table_width]) }

	register(:roster_data_file) { "default_roster.yml" }

	DIR_STRUCTURE = {
		areas: %w(_areas),
		assets: %w(assets),
		area_maps: %w(assets area_maps),
		char_sheets: %w(assets char_sheets),
		player_images: %w(assets player_images),
		data: %w(_data),
		area_items: %w(_data area_items),
		mobs: %w(_mobs),
		rosters: %w(_rosters),
		rules: %w(_rules)
	}

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

		def dir(name)
			unless @dirs_hash
				@dirs_hash = Hash.new do |hash, key|
					unless DIR_STRUCTURE.key?(key)
						raise IstariError,
							"Looking for dir #{key.to_s} but it's not part of the dir structure"
					end
					hash[key] = DIR_STRUCTURE[key].inject(istari_root) do |root, sub_dir|
						root + sub_dir
					end
				end
			end
			@dirs_hash[name]
		end

		def dirs
			DIR_STRUCTURE.keys
		end

		def mobs_file
			# istari_root + "_data" + "mobs.yml"
			mobs_dir + "mobs.yml"
		end

		def mobs_dir
			# istari_root + "_mobs"
			dir(:mobs)
		end

		def rules_dir
			# istari_root + "_rules"
			dir(:rules)
		end

		def rc
			rc_file = istari_root + ".istarirc"
			YAML.load(rc_file.read) || {}
		end

		def areas_dir
			dir(:areas)
			# istari_root + "_areas"
		end

		def area_items_dir
			dir(:area_items)
			# istari_root + "_data" + "area_items"
		end

		def roster_data_file
			roster_hash = YAML.load(dir(:rosters).children.first.read)
			roster_data_file_name = roster_hash["data_file"] + ".yml"
			dir(:data) + roster_data_file_name
		end

		def mobs_get
			self[:mobs_loader].call
		end

		def mobs_save(mobs)
			saver = self[:mobs_saver].new(mobs_file: mobs_file, writer: self[:writer])
			mobs.save(saver)
		end

		def create_mob_page(mob)
			saver = self[:mob_page_saver].new(mobs_dir: mobs_dir, writer: self[:writer])
			saver.call(mob)
		end

		def mobs_table
			self[:mobs_table]
		end

		def areas_get
			self[:areas_loader].call
		end

		def items_save(area)
			saver = self[:items_saver].new(items_dir: area_items_dir, writer: self[:writer])
			area.save(saver)
		end

		def areas_save(areas)
			saver = self[:areas_saver].new(areas_dir: areas_dir, writer: self[:writer])
			areas.save(saver)
		end

		def areas_table
			self[:areas_table]
		end

		def items_table
			self[:items_table]
		end

		def rules_get
			self[:rules_loader].call
		end

		def rules_save(rules)
			saver = self[:rules_saver].new(rules_dir: rules_dir, writer: self[:writer])
			rules.save(saver)
		end

		def rules_table
			self[:rules_table]
		end

		def roster_get
			self[:roster_loader].call
		end

		def roster_save(roster)
			saver = self[:roster_saver].new(roster_data_file: roster_data_file, writer: self[:writer])
			roster.save(saver)
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
