require 'spec_helper'

RSpec.describe 'Sync'do
  context 'with files to backup only' do
    before do
      File.open(File.expand_path('~/.vimrc'), 'w') { |f| f << 'content' }
      File.open(File.expand_path('~/.gvimrc'), 'w') { |f| f << 'content' }
      FileUtils.mkdir_p(File.expand_path('~/Library/Application Support/Dash'))
      File.open(File.expand_path('~/Library/Application Support/Dash/library.dash'), 'w') { |f| f << 'content' }
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
  end

  context 'with files to restore only' do
    before do
      create_dutiful_dir
      File.open(File.expand_path('~/Dropbox/dutiful/.vimrc'), 'w') { |f| f << 'content' }
      File.open(File.expand_path('~/Dropbox/dutiful/.gvimrc'), 'w') { |f| f << 'content' }
      FileUtils.mkdir_p(File.expand_path('~/Dropbox/dutiful/Library/Application Support/Dash'))
      File.open(File.expand_path('~/Dropbox/dutiful/Library/Application Support/Dash/library.dash'), 'w') { |f| f << 'content' }
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
  end

  context 'with files to backup and restore' do
    before do
      create_dutiful_dir
      File.open(File.expand_path('~/.vimrc'), 'w') { |f| f << 'content' }
      File.open(File.expand_path('~/Dropbox/dutiful/.vimrc'), 'w') { |f| f << 'content' }
    end

    it 'copies the files with greater timestamp to the backup' do
      File.open(File.expand_path('~/.vimrc'), 'w') { |f| f << 'new content' }

      expect { Dutiful::Application.new("#{Dutiful.dir}/db/vim.toml").sync }.to change {
        File.open(File.expand_path('~/Dropbox/dutiful/.vimrc')) { |f| f.read }
      }.to('new content')
    end

    it 'overwrites the files with smaller timestamps' do
      File.open(File.expand_path('~/Dropbox/dutiful/.vimrc'), 'w') { |f| f << 'new content' }

      expect { Dutiful::Application.new("#{Dutiful.dir}/db/vim.toml").sync }.to change {
        File.open(File.expand_path('~/.vimrc')) { |f| f.read }
      }.to('new content')
    end
  end
end
