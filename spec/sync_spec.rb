require 'spec_helper'

RSpec.describe 'Sync'do
  context 'with files to backup only' do
    before { File.open(File.expand_path('~/.vimrc'), 'w') { |f| f << 'content' } }

    it 'creates the backup file directories' do
      Dutiful::Application.new('db/vim.toml').sync

      expect(Dir.exists? File.expand_path('~/Dropbox/dutiful')).to eq true
    end

    it 'backup the files' do
      Dutiful::Application.new('db/vim.toml').sync

      expect(File.exist? File.expand_path('~/Dropbox/dutiful/.vimrc')).to eq true
    end
  end

  context 'with files to restore only' do
    before { File.open(File.expand_path('~/Dropbox/dutiful/.vimrc'), 'w') { |f| f << 'content' } }

    it 'restores the files' do
      Dutiful::Application.new('db/vim.toml').sync

      expect(File.exist? File.expand_path('~/.vimrc')).to eq true
    end
  end

  context 'with files to backup and restore' do
    before do
      File.open(File.expand_path('~/.vimrc'), 'w') { |f| f << 'content' }
      File.open(File.expand_path('~/Dropbox/dutiful/.vimrc'), 'w') { |f| f << 'content' }
    end

    it 'copies the files with greater timestamp to the backup' do
      File.open(File.expand_path('~/.vimrc'), 'w') { |f| f << 'new content' }

      expect { Dutiful::Application.new('db/vim.toml').sync }.to change {
        File.open(File.expand_path('~/Dropbox/dutiful/.vimrc')) { |f| f.read }
      }.to('new content')
    end

    it 'overwrites the files with smaller timestamps' do
      create_dutiful_dir
      File.open(File.expand_path('~/Dropbox/dutiful/.vimrc'), 'w') { |f| f << 'new content' }

      expect { Dutiful::Application.new('db/vim.toml').sync }.to change {
        File.open(File.expand_path('~/.vimrc')) { |f| f.read }
      }.to('new content')
    end
  end
end
