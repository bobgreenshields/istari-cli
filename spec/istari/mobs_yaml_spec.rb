require_relative '../../lib/istari/mobs_yaml'

include Istari

describe MobsYaml do
correct_output = <<-CORRECT
a:
	pp: "12"
	loot: "a loot"
	desc: "a desc"

b:
	pp: "14"
	loot: "b loot"
	desc: "b desc"

CORRECT

	describe '#call' do
		let(:mob_hash_a) { {"pp" => 12, "loot" => "a loot", "desc" => "a desc"} }
		let(:mob_hash_b) { {"pp" => 14, "loot" => "b loot", "desc" => "b desc"} }
		let(:mobs_hash) { {"a" => mob_hash_a, "b" => mob_hash_b} }
		let(:mobs) { Mobs.from_hash(mobs_hash) }
		it 'returns the correct yaml' do
			expect(MobsYaml.new.call(mobs)).to eql(correct_output)
		end
	end
end

