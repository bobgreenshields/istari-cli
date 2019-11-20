require_relative '../lib/istari'
require 'dry/container/stub'
require 'pathname'

Istari.enable_stubs!

describe Istari do
	it 'registers istari_root' do
		Istari.stub(:search_root, Pathname.new("spec/fixture").expand_path)
		expect(Istari[:search_root].to_s).to eql("/home/bobg/dev/istari-cli/spec/fixture")
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
end
