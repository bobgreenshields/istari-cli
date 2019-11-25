require_relative '../../lib/istari/roster_item'
require_relative '../../lib/istari/roster'

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
