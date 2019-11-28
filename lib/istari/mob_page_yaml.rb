require 'erb'


module Istari
	class MobPageYaml
		attr_reader :mob

		def initialize(mobs_dir:, writer:)
			@mobs_dir = mobs_dir
			@writer = writer
		end

		def template
			<<-TEMPLATE
---
layout: mob
mob: <%= mob.id %>

player_images:
---

TEMPLATE
		end

		def get_binding
			binding()
		end

		def call(mob)
			@mob = mob
			file_name = "#{mob.id}.md"
			renderer = ERB.new(template, 0, '>')
			@writer.call(file: @mobs_dir + file_name, content: renderer.result(get_binding))
		end
		
	end
end
