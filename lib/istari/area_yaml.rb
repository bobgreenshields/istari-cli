require_relative 'areas'
require 'erb'


module Istari
	class AreaYaml
		attr_reader :areas

		def initialize(areas_dir:, writer:)
			@areas_dir = areas_dir
			@writer = writer
		end

		def template
			<<-TEMPLATE
---
layout: area
title: "<%= @area.title %>"
number: <%= @area.number.to_s %>

description: "<%= @area.description %>"
categories: area
player_images:
leads_to:
<% @area.leads_to do |adjoin| %>
	- <%= adjoin.to_s %>

<% end %>
---

TEMPLATE
		end

		def get_binding
			binding()
		end

		def call(area)
			@area = area
			file_name = format('%02d', area.number) + "-" +
				area.title.downcase.gsub(/\s+/, '-').gsub(/[^a-z0-9\-]/, '') + ".md"
			renderer = ERB.new(template, 0, '>')
			@writer.call(file: @areas_dir + file_name, content: renderer.result(get_binding))
		end
		
	end
end
