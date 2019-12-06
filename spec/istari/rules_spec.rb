require_relative '../../lib/istari/rule'
require_relative '../../lib/istari/rules'

include Istari

describe Rules do
	let(:rule_hash_1) { {"summary" => "Cover stuff", "title" => "Cover" } }
	let(:rule_hash_2) { {"summary" => "Death saves stuff", "title" => "Death saves" } }
	let(:rule_hash_3) { {"summary" => "Stealth stuff", "title" => "Stealth" } }
	let(:rule_1) { Rule.from_hash(rule_hash_1) }
	let(:rule_2) { Rule.from_hash(rule_hash_2) }
	let(:rule_3) { Rule.from_hash(rule_hash_3) }
	let(:rules_array) { [ rule_hash_1, rule_hash_2 ] }

	describe '.new' do
		it 'returns an empty rules' do
			expect(Rules.new.count).to eql 0
		end
	end

	describe '.from_array' do
		it 'populates the rules object with rules' do
			rules = Rules.from_array(rules_array)
			expect(rules.count).to eql 2
		end
		it 'creates no rules to save' do
			to_save = []
			saver =  ->(rule) { to_save << rule.title }
			rules = Rules.from_array(rules_array)
			rules.save(saver)
			expect(to_save).to contain_exactly()
		end
	end

	describe '#push' do
		it 'adds a rule' do
			rules = Rules.from_array(rules_array)
			rules.push(rule_3)
			expect(rules.count).to eql 3
		end

		it 'adds the rule to save' do
			to_save = []
			saver =  ->(rule) { to_save << rule.title }
			rules = Rules.from_array(rules_array)
			rules.push(rule_3)
			rules.save(saver)
			expect(to_save).to contain_exactly("Stealth")
		end
	end

	describe "#[]" do
		it 'returns the rule with that title' do
			rules = Rules.from_array(rules_array)
			rules.push(rule_3)
			expect(rules["Stealth"]).to be_a Istari::Rule
			expect(rules["Stealth"].title).to eql("Stealth")
			expect(rules["Cover"].title).to eql("Cover")
		end
	end

	describe '#has_title?' do
		context 'when no rules with that title are present' do
			it 'returns false' do
				rules = Rules.new.push(rule_1).push(rule_2)
				expect(rules.has_title?("Stealth")).to be_falsey
			end
			context 'when an rule with that title is present' do
				it 'returns true' do
					rules = Rules.new.push(rule_1).push(rule_2).push(rule_3)
					expect(rules.has_title?("Stealth")).to be_truthy
				end
			end
		end
	end

	
end
