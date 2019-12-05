require_relative '../../lib/istari/area'

include Istari

describe Area do
	let(:area_hash) { { "number" => "1", "title" => "Entrance",
		"description" => "Dungeon entrance",
		"player_images" => [ "goblin", "bugbear" ], "leads_to" => [ "2", "3" ],
		"items" => [ { "title" => "A: Chest", "description" => "A locked chest" },
								{ "title" => "B: Bottles", "description" => "Wine bottles" } ]
	} }
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
			expect(area.player_images).to contain_exactly("goblin", "bugbear")
			expect(area.leads_to).to contain_exactly(2, 3)
			expect(area.items.map(&:title)).to contain_exactly("A: Chest",
																												 "B: Bottles")
		end
	end

	describe '#add_item' do
		it 'adds items to the items array' do
			area = Area.new(1)
			area.add_item(title: "A: pile of treasure", description: "500gp")
			area.add_item(title: "B: statue", description: "A stationary gargoyle")
			expect(area.items.map(&:title)).to contain_exactly("A: pile of treasure",
																												"B: statue")
		end
	end

	describe "#item_count" do
		context 'when there are no items' do
			it 'returns 0' do
				area = Area.new(1)
				expect(area.item_count).to eql(0)
			end
		end
		context 'when there are items in the array' do
			it 'returns the number of items held in the area' do
				area = Area.new(1)
				area.add_item(title: "A: pile of treasure", description: "500gp")
				area.add_item(title: "B: statue", description: "A stationary gargoyle")
				expect(area.item_count).to eql(2)
			end
		end
	end

	describe "#items?" do
		context 'when there are no items' do
			it 'returns false' do
				area = Area.new(1)
				expect(area.items?).to be_falsey
			end
		end
		context 'when there are items in the array' do
			it 'returns true' do
				area = Area.new(1)
				area.add_item(title: "A: pile of treasure", description: "500gp")
				area.add_item(title: "B: statue", description: "A stationary gargoyle")
				expect(area.items?).to be_truthy
			end
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

