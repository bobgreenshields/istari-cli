require 'roster_item'

describe RosterItem do
	describe '.missing_keys' do
		context 'when area and mob present' do
			let(:item_hash) { {"area" => "3", "mob" => "Klarg"} }
			it 'returns an empty array' do
				expect(RosterItem.missing_keys(item_hash)).to match_array []
			end
		end

		context 'when area and mob are missing' do
			let(:item_hash) { { "notes" => "a goblin"} }
			it 'returns an array with area and mob' do
				expect(RosterItem.missing_keys(item_hash)).to contain_exactly("area", "mob")
			end
		end
	end
	
	describe '#area' do
		context 'when set as an integer' do
			it 'returns a integer' do
				item = RosterItem.new
				item.area = 2
				expect(item.area).to eql(2)
			end
		end

		context 'when given an invalid string' do
			it 'raises an error' do
				item = RosterItem.new
				expect { item.area = "this" }.to raise_error(RosterItemError)
			end
		end

		context 'when given a string of integer with whitespace' do
			it 'ignores the whitespace' do
				item = RosterItem.new
				item.area = " 24  "
				expect(item.area).to eql(24)
			end
		end

		context 'when given a string integer with a plus' do
			it 'returns a positive integer' do
				item = RosterItem.new
				item.area = " +24  "
				expect(item.area).to eql(24)
			end
		end

		context 'when given a string integer with a minus sign' do
			it 'returns a negative integer' do
				item = RosterItem.new
				item.area = " -24  "
				expect(item.area).to eql(-24)
			end
		end
	end

	describe '#mob' do
		context 'when mob has leading and trailing whitespace' do
			it 'trims whitespace' do
				item = RosterItem.new
				item.mob = "   Klarg  "
				expect(item.mob).to eql("Klarg")
			end
		end	

		context 'when mob has a capital letters' do
			it 'mob_id is all lower case' do
				item = RosterItem.new
				item.mob = "   KlaRg  "
				expect(item.mob_id).to eql("klarg")
			end
		end
	end

	describe '.from_hash' do
		let(:item_hash) { {"area" => "3", "mob" => "Klarg", "notes" => "the leader  "} }
		it 'creates a RosterItem' do
			expect(RosterItem.from_hash(item_hash)).to be_a(RosterItem)
		end

		it 'populates the values' do
			item = RosterItem.from_hash(item_hash)
			expect(item.area).to eql(3)
			expect(item.mob).to eql("Klarg")
			expect(item.mob_id).to eql("klarg")
			expect(item.notes).to eql("the leader")
		end

		context 'when missing an area key' do
			let(:item_hash) { {"mob" => "Klarg", "notes" => "the leader  "} }
			it 'raises an error' do
				expect { RosterItem.from_hash(item_hash) }.to raise_error(RosterItemError)
			end
		end

		context 'when missing an mob key' do
			let(:item_hash) { {"area" => "3", "notes" => "the leader  "} }
			it 'raises an error' do
				expect { RosterItem.from_hash(item_hash) }.to raise_error(RosterItemError)
			end
		end

		context 'when missing a notes key' do
			let(:item_hash) { {"area" => "3", "mob" => "Klarg"} }
			it 'inserts an empty string' do
				item = RosterItem.from_hash(item_hash)
				expect(item.area).to eql(3)
				expect(item.mob).to eql("Klarg")
				expect(item.mob_id).to eql("klarg")
				expect(item.notes).to eql("")
			end
			
		end
	end
	
end
