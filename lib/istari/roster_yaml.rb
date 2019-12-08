require 'erb'


module Istari
	class RosterYaml
		attr_reader :roster

		def initialize(roster_data_file:, writer:)
			@roster_data_file = roster_data_file
			@writer = writer
		end

		def template
			<<-TEMPLATE
<% roster.each do |item| %>
- mob: <%= item.mob_id %>

  area: <%= item.area %>

  notes: "<%= item.notes %>"

<% end %>
TEMPLATE
		end

		def get_binding
			binding()
		end

		def call(roster)
			@roster = roster
			renderer = ERB.new(template, 0, '>')
			@writer.call(file: @roster_data_file, content: renderer.result(get_binding))
		end
		
	end
end
