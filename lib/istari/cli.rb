require 'thor'
require 'pathname'
require 'fileutils'
require_relative '../istari'
require_relative './cli/mobs'
require_relative './cli/areas'
require_relative './cli/roster'
require_relative './cli/items'
require_relative './cli/rules'

module Istari
	module Cli
		class App < Thor
			desc "mobs SUBCOMMAND ...ARGS", "create and manage the encounter's mobs"	
			subcommand "mobs", Istari::Cli::Mobs

			desc "areas SUBCOMMAND ...ARGS", "create and manage the encounter's areas"	
			subcommand "areas", Istari::Cli::Areas

			desc "roster SUBCOMMAND ...ARGS", "create and manage the encounter's roster"	
			subcommand "roster", Istari::Cli::Roster

			desc "items SUBCOMMAND ...ARGS", "create and list items of interest for areas"	
			subcommand "items", Istari::Cli::Items

			desc "rules SUBCOMMAND ...ARGS", "create and list rules pages"	
			subcommand "rules", Istari::Cli::Rules

			desc "init", "initialise a new project"
			def init
				init_dirs
				backup_existing_files
				load_default_files
				copy_over_rules
			end

			private

			def init_dirs
				say "+++ Checking all directories are present +++"
				Istari.dirs.each do |dir_name|
					dir = Istari.dir(dir_name)
					if dir.exist?
						say "#{dir_name} found at #{dir.to_s}"
					else
						dir.mkpath
						say "#{dir_name} created at #{dir.to_s}"
					end
				end
			end

			def backup_existing_files
				backup = Istari[:backup]
				say "+++ Backing up and clearing out exisitng files+++"
				Istari.dirs.each do |dir_name|
					dir = Istari.dir(dir_name)
					next unless dir.exist?
					say "+ Checking #{dir_name} directory +"
					dir.children do |child|
						next unless child.file?
						say "Backing up #{child.basename.to_s}"
						backup.call(child)
					end
				end
			end

			def load_default_files
			end

			def copy_over_rules
				template_dir = Pathname.new(Istari.rc.fetch("rules_dir") { return })
				return unless template_dir.directory?
				template_dir.each_child do |child|
					next unless child.extname == '.md'
					target = Istari.rules_dir + child.basename
					FileUtils.cp(child, target) unless target.exist?
				end
			end

		end
	end
end
