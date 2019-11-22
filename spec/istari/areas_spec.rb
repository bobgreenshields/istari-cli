require_relative '../../lib/istari/area'
require_relative '../../lib/istari/areas'

include Istari

describe Areas do
	let(:area_hash_1) { {"number" => "1", "title" => "Entrance" } }
	let(:area_hash_2) { {"number" => "2", "title" => "Hallway" } }
	let(:area_hash_3) { {"number" => "3", "title" => "Room" } }
	let(:area_1) { Area.from_hash(area_hash_1) }
	let(:area_2) { Area.from_hash(area_hash_2) }
	let(:area_3) { Area.from_hash(area_hash_3) }

	describe '.new' do
		it 'returns an empty Areas' do
			expect(Areas.new.count).to eql 0
		end
	end
	describe '#push' do
		it 'adds an area' do
			areas = Areas.new.push(area_1).push(area_2)
			expect(areas.count).to eql 2
		end
	end

	
end
