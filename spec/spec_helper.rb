require "bundler/setup"
# require "istari/cli"

lib_dir = File.join(File.dirname(__FILE__), '../lib')
full_lib_dir = File.expand_path(lib_dir)
$LOAD_PATH.unshift(full_lib_dir) unless
	$LOAD_PATH.include?(lib_dir) || $LOAD_PATH.include?(full_lib_dir)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
