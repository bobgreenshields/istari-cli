require 'pathname' 
module Istari
	class BackupTime
		def initialize(backup_dir)
			@backup_dir = Pathname.new(backup_dir)
		end

		def call(file_to_backup)
			file_to_backup_path = Pathname.new(file_to_backup)
			return unless file_to_backup_path.exist?
			@backup_dir.mkdir unless @backup_dir.exist?
			new_name = file_to_backup_path.basename.to_s + Time.now.strftime(".%Y%m%d%H%M%S.bak")
			file_to_backup_path.rename(@backup_dir + new_name)
		end
	end
end
