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
	let(:areas_array) { [ area_hash_1, area_hash_2 ] }

	describe '.new' do
		it 'returns an empty Areas' do
			expect(Areas.new.count).to eql 0
		end
	end

	describe '.from_array' do
		it 'populates the areas object with areas' do
			areas = Areas.from_array(areas_array)
			expect(areas.count).to eql 2
		end
		it 'creates no areas to save' do
			to_save = []
			saver =  ->(area) { to_save << area.number }
			areas = Areas.from_array(areas_array)
			areas.save(saver)
			expect(to_save).to contain_exactly()
		end
	end
	describe '#push' do
		it 'adds an area' do
			areas = Areas.from_array(areas_array)
			areas.push(area_3)
			expect(areas.count).to eql 3
		end

		it 'adds the area to save' do
			to_save = []
			saver =  ->(area) { to_save << area.number }
			areas = Areas.from_array(areas_array)
			areas.push(area_3)
			areas.save(saver)
			expect(to_save).to contain_exactly(3)
		end
	end

	describe '#has_number?' do
		context 'when no areas with that number are present' do
			it 'returns false' do
				areas = Areas.new.push(area_1).push(area_2)
				expect(areas.has_number?(3)).to be_falsey
			end
			context 'when an area with that number is present' do
				it 'returns true' do
					areas = Areas.new.push(area_1).push(area_2).push(area_3)
					expect(areas.has_number?(3)).to be_truthy
				end
			end
		end
	end

	
end
