require 'mobs'
require 'mob'

describe Mobs do
	let(:mob_hash_1) { {"pp" => "9", "loot" => "15sp", "desc" => "a goblin"} }
	let(:mob_hash_2) { {"pp" => "13", "loot" => "33gp", "desc" => "an owlbear"} }
	let(:mobs_hash) { {"a" => mob_hash_1, "owlbear" => mob_hash_2} }

	describe '#push' do
		let(:mob1) { Mob.new("a") }
		let(:mob2) { Mob.new("b") }
		let(:mob3) { Mob.new("owlbear") }
		let(:mobs) { Mobs.new }

		it 'adds a mob object' do
			mobs.push(mob3).push(mob2).push(mob1)
			expect(mobs.has_id?("a")).to be_truthy
		end

		context 'when it already contains a mob with the same id' do
			# mob ids are always lower case
			let(:mob4) { Mob.new("B") }

			it 'raises a MobsError' do
				mobs.push(mob3).push(mob2).push(mob1)
				expect { mobs.push(mob4) }.to raise_error(MobsError)	
			end
		end
			
	end
	
	
	describe '.new' do
		it 'returns a mobs object' do
			mobs = Mobs.new
			expect(mobs).to be_a Mobs
		end
	end

	describe '.from_hash' do
		it 'returns a mobs object' do
			expect(Mobs.from_hash(mobs_hash)).to be_a Mobs
		end
	end
	
end
