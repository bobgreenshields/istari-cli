require 'thor'
require 'pathname'
require 'fileutils'
require_relative '../istari'
require_relative './cli/mobs'
require_relative './cli/areas'
require_relative './cli/roster'
require_relative './cli/items'

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

			desc "init", "initialise a new project"
			def init
				sub_dirs = {  "." => %w(_areas assets _data _mobs _rosters _rules),
											"assets" => %w(area_maps char_sheets player_images),
											"_data" => %w(area_items) }
				sub_dirs.each do |dir, sub_dir_array|
					sub_dir_array.each do |sub_dir|
						target = Istari.istari_root + dir + sub_dir
						target.mkdir unless target.exist?
					end
				end
				template_dir = Pathname.new(Istari.rc.fetch("rules_dir") { return })
				return unless template_dir.directory?
				template_dir.each_child do |child|
					next unless child.extname == '.md'
					target = Istari.rules_dir + child.basename
					FileUtils.cp(child, target) unless target.exist?
				end
			end

			private

		end
	end
end
