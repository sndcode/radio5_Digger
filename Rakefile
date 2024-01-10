# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop)

RuboCop::RakeTask.new("rubocop:md") do |task|
  task.options << %w[-c .rubocop-md.yml]
end

task default: %i[rubocop rubocop:md spec]
