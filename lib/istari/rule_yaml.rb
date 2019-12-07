require 'erb'


module Istari
	class RuleYaml
		attr_reader :rule

		def initialize(rules_dir:, writer:)
			@rules_dir = rules_dir
			@writer = writer
		end

		def template
			<<-TEMPLATE
---
layout: rule
title: "<%= rule.title %>"
summary: "<%= rule.summary %>"
<% if  rule.title_link? %>
title_link: "<%= rule.title_link %>"
<% end %>
---

An interesting rule

TEMPLATE
		end

		def get_binding
			binding()
		end

		def call(rule)
			@rule = rule
			file_name = rule.title.downcase.gsub(/\s+/, '-').gsub(/[^a-z0-9\-]/, '') + ".md"
			renderer = ERB.new(template, 0, '>')
			@writer.call(file: @rules_dir + file_name, content: renderer.result(get_binding))
		end
		
	end
end
