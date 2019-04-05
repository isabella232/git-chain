require File.expand_path('../../vendor/bootstrap.rb', __FILE__)
require 'git_chain'

require 'minitest'
require 'mocha/mini_test'
require "minitest/autorun"
require 'minitest/reporters'

MiniTest::Reporters.use!

require 'tmpdir'
require 'fileutils'
require 'tempfile'
require 'open3'

module RepositoryTestHelper
  def with_test_repository(fixture_name = 'a-b')
    previous_dir = Dir.pwd
    setup_script = File.expand_path("../../fixtures/#{fixture_name}.sh", __FILE__)

    Dir.mktmpdir('git-chain-rebase') do |dir|
      begin
        Dir.chdir(dir)
        _, err, stat = Open3.capture3(setup_script)
        raise "Cannot setup git repository using #{setup_script}: #{err}" unless stat.success?

        yield
      ensure
        Dir.chdir(previous_dir) if previous_dir
      end
    end
  end
end
