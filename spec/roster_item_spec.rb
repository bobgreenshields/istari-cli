require 'roster_item'

describe RosterItem do
	describe '#area' do
		context 'when set as an integer' do
			it 'returns a string' do
				item = RosterItem.new
				item.area = 2
				expect(item.area).to eql("2")
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
				expect(item.area).to eql("24")
			end
		end
	end
	
end
