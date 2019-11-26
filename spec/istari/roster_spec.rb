require_relative '../../lib/istari/roster_item'
require_relative '../../lib/istari/roster'
require_relative '../../lib/istari/mob'
require_relative '../../lib/istari/mobs'

include Istari

describe Roster do
	let(:item_hash_1) { {"mob" => "a", "area" => 1 } }
	let(:item_hash_2) { {"mob" => "b", "area" => 2 } }
	let(:item_hash_3) { {"mob" => "c", "area" => 3 } }
	let(:item_1) { RosterItem.from_hash(item_hash_1) }
	let(:item_2) { RosterItem.from_hash(item_hash_2) }
	let(:item_3) { RosterItem.from_hash(item_hash_3) }
	let(:items_array) { [ item_hash_1, item_hash_2 ] }

	describe '.new' do
		it 'returns an empty Roster' do
			expect(Roster.new.count).to eql 0
		end
	end

	describe '#unplaced_mobs' do
		let(:mob_1) { Mob.new("a") }
		let(:mob_2) { Mob.new("b") }
		let(:mob_3) { Mob.new("c") }
		let(:mob_4) { Mob.new("d") }
		let(:mobs) { Mobs.new.push(mob_1).push(mob_2).push(mob_3).push(mob_4) }
		it 'only yields mobs not in the roster' do
			roster = Roster.from_array(items_array)
			unplaced_ids = roster.unplaced_mobs(mobs).map(&:id)
			expect(unplaced_ids).to contain_exactly("c", "d")
		end
	end

	describe '.from_array' do
		it 'populates the roster object with items' do
			roster = Roster.from_array(items_array)
			expect(roster.count).to eql 2
		end
		it 'creates no items to save' do
			to_save = []
			saver =  ->(item) { to_save << item }
			roster = Roster.from_array(items_array)
			roster.save(saver)
			expect(to_save).to contain_exactly()
		end
	end
	describe '#push' do
		it 'adds an item' do
			roster = Roster.from_array(items_array)
			roster.push(item_3)
			expect(roster.count).to eql 3
		end

		it 'adds the item to save' do
			to_save = []
			saver =  ->(item) { to_save << item }
			roster = Roster.from_array(items_array)
			roster.push(item_3)
			roster.save(saver)
			expect(to_save).to contain_exactly(roster)
		end
	end

	describe '#has_mob?' do
		context 'when no items with that mob are present' do
			it 'returns false' do
				roster = Roster.new.push(item_1).push(item_2)
				expect(roster.has_mob?("c")).to be_falsey
			end
			context 'when an item with that mob is present' do
				it 'returns true' do
					roster = Roster.new.push(item_1).push(item_2).push(item_3)
					expect(roster.has_mob?("c")).to be_truthy
				end
			end
		end
	end

	
end
