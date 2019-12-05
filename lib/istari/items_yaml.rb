require_relative 'areas'
require 'erb'


module Istari
	class ItemsYaml
		Item = Struct.new(:title, :desc)
		attr_reader :items

		def initialize(items_dir:, writer:)
			@items_dir = items_dir
			@writer = writer
		end

		def template
			<<-TEMPLATE
<% items.each do |item| %>
- title: "<%= item.title %>"
  desc: |-
    <%= item.description.gsub("\n", "\n    ") %>


<% end %>
TEMPLATE
		end

		def get_binding
			binding()
		end

		def call(area)
			return unless area.items?
			@items = area.items
			file_name = format('%02d', area.number) + ".yml"
			renderer = ERB.new(template, 0, '>')
			@writer.call(file: @items_dir + file_name, content: renderer.result(get_binding))
		end
		
	end
end
