require_relative '../lib/istari'
require_relative '../lib/istari/mobs'
require 'dry/container/stub'
require 'pathname'

Istari.enable_stubs!

describe Istari do
	describe '[]:search_root' do
		it 'registers istari_root' do
			# Istari.stub(:search_root, Pathname.new("spec/fixture").expand_path)
			Istari.stub(:search_root, Pathname.new("spec/fixture/_data").expand_path)
			expect(Istari[:search_root].to_s).to eql("/home/bobg/dev/istari-cli/spec/fixture/_data")
		end
	end

	describe '.find_istari_root' do
		it 'returns a Pathname' do
			expect(Istari.find_istari_root).to be_a Pathname
		end
		it 'returns the dir containing .istarirc' do
			Istari.stub(:search_root, Pathname.new("spec/fixture/_data").expand_path)
			expect(Istari.find_istari_root.to_s).to eql("/home/bobg/dev/istari-cli/spec/fixture")
		end
		context 'when run in a non Istari dir' do
			it 'raises an error' do
				Istari.stub(:search_root, Pathname.new("/home/bobg").expand_path)
				expect { Istari.find_istari_root }.to raise_error(StandardError)
			end
		end
	end

	describe '.mobs_file' do
		it 'returns the location of mobs.yml' do
			Istari.stub(:search_root, Pathname.new("spec/fixture/_data").expand_path)
			expect(Istari.mobs_file).to be_a Pathname
			expect(Istari.mobs_file.to_s).to eql("/home/bobg/dev/istari-cli/spec/fixture/_data/mobs.yml")
		end
	end

	describe '.mobs_get' do
		it 'retunds a populated mobs object' do
			expect(Istari.mobs_get).to be_a Istari::Mobs
		end
	end

end
