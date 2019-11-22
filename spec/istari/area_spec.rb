require_relative '../../lib/istari/area'

include Istari

describe Area do
	let(:area_hash) { { "number" => "1", "title" => "Entrance",
		"description" => "Dungeon entrance",
		"player_images" => [ "goblin", "bugbear" ], "leads_to" => [ "2", "3" ] } }
	describe '.new' do
		it 'returns an area object with the correct number' do
			expect(Area.new(15)).to be_a Istari::Area
		end
		context 'when passed a number as a string ' do
			it 'converts it to an integer' do
				expect(Area.new("12").number).to eql 12
			end
		end
	end	

	describe ".from_hash" do
		it 'returns an area' do
			expect(Area.from_hash(area_hash)).to be_a Istari::Area
		end

		it 'populates the attributes' do
			area = Area.from_hash(area_hash)
			expect(area.title).to eql "Entrance"
			expect(area.description).to eql "Dungeon entrance"
		end
	end

	describe '#player_images' do
		it 'yields the player images' do
			area = Area.from_hash(area_hash)
			expect { |b| area.player_images(&b) }.to yield_successive_args("goblin", "bugbear")
		end
	end

	describe '#leads_to' do
		it 'yields the area integers' do
			area = Area.from_hash(area_hash)
			expect { |b| area.leads_to(&b) }.to yield_successive_args(2, 3)
		end
	end
end

