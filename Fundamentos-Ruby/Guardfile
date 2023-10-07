# A sample Guardfile for RSpec

# Specify the command to run RSpec (with bundler)
guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # Watch RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Watch files in the lib directory
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
