require 'mob'

describe Mob do
	let(:mob_hash) { {"pp" => "9", "loot" => "15sp", "desc" => "a goblin"} }
	
	describe ".from_hash" do
		it 'returns a mob' do
			expect(Mob.from_hash("klarg", mob_hash)).to be_a Mob
		end

		it 'populates the attributes' do
			mob = Mob.from_hash("klarg", mob_hash)
			expect(mob.pp).to eq ("9")
			expect(mob.loot).to eq ("15sp")
			expect(mob.desc).to eq ("a goblin")
		end
	end

	describe '#pp=' do
		context 'when given a string' do
			it 'returns a string' do
				expect(Mob.from_hash("klarg", mob_hash).pp).to be_a String
			end
		end

		context 'when given an integer' do
			let(:mob_hash_integer) { {"pp" => 9, "loot" => "15sp", "desc" => "a goblin"} }
			it 'returns a string' do
				expect(Mob.from_hash("klarg", mob_hash_integer).pp).to be_a String
				expect(Mob.from_hash("klarg", mob_hash_integer).pp).to eq "9"
			end
		end
	end

	describe '#<=>' do
		it 'compares ids' do
			mob_a = Mob.from_hash("a", mob_hash)
			mob_a2 = Mob.from_hash("a", mob_hash)
			mob_b = Mob.from_hash("b", mob_hash)
			expect(mob_a <=> mob_a2).to eq 0
			expect(mob_a <=> mob_b).to eq -1
		end
	end



end
