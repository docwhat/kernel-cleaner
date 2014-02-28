require_relative '../kernel-cleaner.rb'
require 'ap'

DPKG_OUTPUT = File.read(File.expand_path '../data/dpkg.output', __FILE__)
UNAME_OUTPUT = "3.2.0-57-generic-pae\n"

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  if ENV['USE_REAL_SYSTEM'].to_s == ''
    config.before do
      App.any_instance.stub(:exec_dpkg_list).and_return(DPKG_OUTPUT)
      App.any_instance.stub(:exec_uname_r).and_return(UNAME_OUTPUT)
    end
  end

end
