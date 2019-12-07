require 'thor'
require_relative '../../istari'

module Istari
	module Cli
		class Rules < Thor

			desc "list", "list all rules"
			def list
				puts Istari.rules_table.call(rules)
			end

			desc "add", "add a rules page"
			def add
				title = ask("Enter the title for the rule").strip
				if title.length == 0
					say("The title of a rule cannot be empty", :red)
					exit
				end
				if rules.title?(title)
					say("A rules page with the title: #{title} already exists", :red)
					exit
				end
				summary = ask("Enter a summary for the rule (return for none)").strip
				puts
				say("The title of a rules page can be a link to a web page")
				title_link = ask("Enter a link for the rule page title (return for none)").strip
				rule = Istari::Rule.new(title).tap do |new_rule|
					new_rule.summary = summary if summary.length > 0
					new_rule.title_link = title_link if title_link.length > 0
				end
				rules.push(rule)
				Istari.rules_save(rules)
			end

			private

			def rules
				@rules || refresh_rules
			end

			def refresh_rules
				@rules = Istari.rules_get
			end
		end
	end
end

