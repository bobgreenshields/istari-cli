require 'party'

data = {}
data["names"] = %w(E B G)
data["rows"] = [ {"category" => "Player", "values" => %w(Col Bryn Luca)} ]
categories = %w(Init AC Prof PP)
categories.each { |cat| data["rows"] << {"category" => cat, "values" => %w(1 2 3)} }

loader_dbl = -> (file_name) { data }

describe Party do
	let(:party) { Party.new("party.yml", loader: loader_dbl ) }

	describe "#names" do
		it 'returns an array' do
			expect(party.names).to be_a Array
		end

		it 'returns the correct names' do
			expect(party.names).to eq %w(E B G)
		end
	end

	describe "#add_name" do
		it 'adds a value to the names array' do
			party2 = Party.new("party.yml", loader: loader_dbl )
			party2.add_name("F")
			expect(party.names).to eq %w(E B G F)
		end	
	end

	describe "#categories" do
		it 'returns an array' do
			expect(party.categories).to be_a Array
		end

		it 'returns the correct values' do
			expect(party.categories).to eq %w(Player Init AC Prof PP)
		end
	end

	describe "#values" do
		it 'returns an array' do
			expect(party.values("AC")).to be_a Array
		end

		it 'returns the correct values' do
			expect(party.values("AC")).to eq %w(1 2 3)
		end
	end

	describe "#add_value" do
		it 'adds a value to a categories array' do
			party2 = Party.new("party.yml", loader: loader_dbl )
			party2.add_value(category: "AC", value: "4")
			expect(party.values("AC")).to eq %w(1 2 3 4)
		end
	end

end
