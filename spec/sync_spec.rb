require 'spec_helper'

RSpec.describe 'Sync'do
  context 'with files to backup only' do
    before do
      create_file '~/.vimrc'
      create_file '~/.gvimrc'
      create_file '~/Library/Application Support/Dash/library.dash'
      create_file '~/Library/Application Support/Popcorn-Time/data/movies.db'
    end

    it 'creates the backup file directories' do
      application = Dutiful::Application.new("#{Dutiful.dir}/db/vim.toml")

      expect { application.sync }.to change {
        Dir.exists? File.expand_path('~/Dropbox/dutiful')
      }.to true
    end

    it 'backup a single file' do
      application = Dutiful::Application.new("#{Dutiful.dir}/db/vim.toml")

      expect { application.sync }.to change { application.files.any? &:has_backup? }.to true
    end

    it 'backup files with spaces' do
      application = Dutiful::Application.new("#{Dutiful.dir}/db/dash.toml")

      expect { application.sync }.to change { application.files.any? &:has_backup? }.to true
    end

    it 'backup all files' do
      application = Dutiful::Application.new("#{Dutiful.dir}/db/vim.toml")

      expect { application.sync }.to change { application.files.all? &:has_backup? }.to true
    end

    it 'backup a directory' do
      application = Dutiful::Application.new("#{Dutiful.dir}/db/popcorn-time.toml")

      expect { application.sync }.to change { application.files.all? &:has_backup? }.to true
    end
  end

  context 'with files to restore only' do
    before do
      create_file '~/Dropbox/dutiful/.vimrc'
      create_file '~/Dropbox/dutiful/.gvimrc'
      create_file '~/Dropbox/dutiful/Library/Application Support/Dash/library.dash'
      create_file '~/Dropbox/dutiful/Library/Application Support/Popcorn-Time/data/movies.db'
    end

    it 'restores a single file' do
      application = Dutiful::Application.new("#{Dutiful.dir}/db/vim.toml")

      expect { application.sync }.to change { application.files.any? &:exist? }.to true
    end

     it 'restores files with spaces' do
      application = Dutiful::Application.new("#{Dutiful.dir}/db/dash.toml")

      expect { application.sync }.to change { application.files.any? &:exist? }.to true
     end

     it 'restores all the files' do
      application = Dutiful::Application.new("#{Dutiful.dir}/db/vim.toml")

      expect { application.sync }.to change { application.files.all? &:exist? }.to true
     end

    it 'restores a directory' do
      application = Dutiful::Application.new("#{Dutiful.dir}/db/popcorn-time.toml")

      expect { application.sync }.to change { application.files.all? &:exist? }.to true
    end
  end

  context 'with files to backup and restore' do
    before do
      create_file '~/.vimrc'
      create_file '~/Dropbox/dutiful/.vimrc'
    end

    it 'copies newer files to the backup' do
      create_file '~/.vimrc', 'new content'

      expect { Dutiful::Application.new("#{Dutiful.dir}/db/vim.toml").sync }.to change {
        read_file '~/Dropbox/dutiful/.vimrc'
      }.to('new content')
    end

    it 'overwrites old files' do
      create_file '~/Dropbox/dutiful/.vimrc', 'new content'

      expect { Dutiful::Application.new("#{Dutiful.dir}/db/vim.toml").sync }.to change {
        read_file '~/.vimrc'
      }.to('new content')
    end
  end
end

def create_file(path, content = 'content')
  FileUtils.mkdir_p File.dirname(File.expand_path path)
  File.open(File.expand_path(path), 'w') { |f| f << content}
end

def read_file(path)
  File.open(File.expand_path(path)) { |f| f.read }
end
