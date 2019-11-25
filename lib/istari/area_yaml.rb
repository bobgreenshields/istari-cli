require_relative 'areas'
require 'erb'


module Istari
	class AreasYaml
		attr_reader :areas

		def template
			<<-TEMPLATE
<% areas.each do |area| %>
<%= area.id %>:
	pp: "<%= area.pp %>"
	loot: "<%= area.loot %>"
	desc: "<%= area.desc %>"

<% end %>
TEMPLATE
		end

		def get_binding
			binding()
		end

		def call(areas)
			@areas = areas
			renderer = ERB.new(template, 0, '>')
			renderer.result(get_binding)
		end
		
	end
end
