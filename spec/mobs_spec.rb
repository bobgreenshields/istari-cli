require 'mobs'

describe Mobs do
	let(:mob_hash_1) { {"pp" => "9", "loot" => "15sp", "desc" => "a goblin"} }
	let(:mob_hash_2) { {"pp" => "13", "loot" => "33gp", "desc" => "an owlbear"} }
	let(:mobs_hash) { {"a" => mob_hash_1, "owlbear" => mob_hash_2} }

	describe '.from_hash' do
		it 'returns a mobs object' do
			expect(Mobs.from_hash(mobs_hash)).to be_a Mobs
		end
	end
	
end
