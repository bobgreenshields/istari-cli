require 'mobs'
require 'mob'

describe Mobs do
	let(:mob_hash_1) { {"pp" => "9", "loot" => "15sp", "desc" => "a goblin"} }
	let(:mob_hash_2) { {"pp" => "13", "loot" => "33gp", "desc" => "an owlbear"} }
	let(:mobs_hash) { {"a" => mob_hash_1, "owlbear" => mob_hash_2} }
	
	describe '.from_hash' do
		it 'returns a mobs object' do
			expect(Mobs.from_hash(mobs_hash)).to be_a Mobs
		end

		it 'contains the new mob objects' do
			mobs = Mobs.from_hash(mobs_hash)
			expect(mobs.has_id?("owlbear")).to be_truthy
			expect(mobs.has_id?("a")).to be_truthy
		end
	end

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

	describe '#next_id' do
		context 'when no mobs have been added' do
			let(:mobs) { Mobs.new }
			it 'returns a' do
				expect(mobs.next_id).to eql("a")
			end
		end

		context 'when mobs have been added' do
			let(:mob1) { Mob.new("a") }
			let(:mob2) { Mob.new("b") }
			let(:mob3) { Mob.new("cat") }
			let(:mob4) { Mob.new("owlbear") }
			let(:mobs) { Mobs.new.push(mob1).push(mob2).push(mob3).push(mob4) }
			it 'returns the next single character' do
					expect(mobs.next_id).to eql("c")
			end
		end
	end

	describe '#each' do
		let(:mob1) { Mob.new("a") }
		let(:mob2) { Mob.new("b") }
		let(:mob3) { Mob.new("cat") }
		let(:mob4) { Mob.new("owlbear") }
		let(:mobs) { Mobs.new.push(mob1).push(mob2).push(mob3).push(mob4) }
		it 'yields the added mobs' do
			mob_id_arr  = []
			mobs.each { |mob| mob_id_arr << mob }
			expect(mob_id_arr.map(&:id)).to contain_exactly("a", "b", "cat", "owlbear")
		end
		
	end
	
end
