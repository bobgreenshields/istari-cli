require_relative 'mobs'
require 'erb'


module Istari
	class MobsYaml
		attr_reader :mobs

		def template
			<<-TEMPLATE
<% mobs.each do |mob| %>
<%= mob.id %>:
	pp: "<%= mob.pp %>"
	loot: "<%= mob.loot %>"
	desc: "<%= mob.desc %>"

<% end %>
TEMPLATE
		end

		def get_binding
			binding()
		end

		def call(mobs)
			@mobs = mobs
			renderer = ERB.new(template, 0, '>')
			renderer.result(get_binding)
		end
		
	end
end
