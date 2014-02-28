guard :bundler do
  watch('Gemfile')
end

guard(
  :rspec,
  cmd: 'bundle exec rspec -f doc --order defined'
) do
  watch(%r{^spec/.+_spec\.rb$})
  watch('kernel-cleaner.rb')    { 'spec/kernel-cleaner_spec.rb' }
  watch('spec/spec_helper.rb')  { "spec" }
end
