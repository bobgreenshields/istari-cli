require_relative '../../lib/istari/rule'

include Istari

describe Rule do
	let(:rule_hash) { { "title" => "Cover",
		"summary" => "half cover -2 ranged attack",
		"title-link" => "https://some-cover-link.html" }
	 }

	describe '.new' do
		it 'returns a rule object with the correct title' do
			expect(Rule.new("Cover")).to be_a Istari::Rule
			expect(Rule.new("Cover").title).to eql("Cover")
		end
	end	

	describe ".from_hash" do
		it 'returns a rule' do
			expect(Rule.from_hash(rule_hash)).to be_a Istari::Rule
		end

		it 'populates the attributes' do
			rule = Rule.from_hash(rule_hash)
			expect(rule.title).to eql "Cover"
			expect(rule.summary).to eql "half cover -2 ranged attack"
			expect(rule.title_link).to eql "https://some-cover-link.html" 
		end
	end

end

