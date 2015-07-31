require 'bundler/setup'
require 'dutiful'
require 'fakefs'
require 'rspec'

Bundler.setup

def clone_dutiful_dir
  FakeFS::FileSystem.clone File.dirname(File.dirname(__FILE__)), '.'
end

def create_dropbox_dir
  FileUtils.mkdir_p(File.expand_path '~/Dropbox')
end

def create_dutiful_dir
  FileUtils.mkdir_p(File.expand_path '~/Dropbox/dutiful')
end

def dir_content(dir)
  Dir[File.expand_path "#{dir}/{*,.*}"]
end

class FakeRsync
  def self.run(src, dest)
    FileUtils.cp src, dest
  end
end

RSpec.configure do |config|
  config.before(:each) do
    stub_const 'Rsync', FakeRsync
    clone_dutiful_dir
    create_dropbox_dir
  end
end
