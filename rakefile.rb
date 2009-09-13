require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.pattern = '*_spec.rb'
  t.spec_opts << '-fs'
  t.rcov = true
  t.rcov_opts << '--exclude' << 'facets,rcov'
end
