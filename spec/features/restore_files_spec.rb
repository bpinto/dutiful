require 'support/feature'

RSpec.describe 'Restore files:' do
  it 'creates the necessary folders for restore' do
    with_application backup_files: 'dutiful-test-folder/.dutiful.test' do
      expect {
        Dutiful::Command::Main.run 'dutiful', ['restore', '-q']
      }.to change { Dir.exist? File.expand_path('~/dutiful-test-folder') }.to true
    end

    FileUtils.remove_entry File.expand_path('~/dutiful-test-folder')
  end

  it 'restore all files' do
    with_application backup_files: '.dutiful.test' do
      expect {
        Dutiful::Command::Main.run 'dutiful', ['restore', '-q']
      }.to change { File.exist? File.expand_path('~/.dutiful.test') }.to true
    end
  end

  it 'restore all files that meet the conditions' do
    file = {
      path: '.dutiful.test',
      condition: { command: 'true', expected_status: 0 }
    }

    ignored_file = {
      path: '.dutiful.test.ignored',
      condition: { command: 'false', expected_status: 0 }
    }

    with_application backup_files: [file, ignored_file] do
      Dutiful::Command::Main.run 'dutiful', ['restore', '-q']

      expect(File.exist? File.expand_path('~/.dutiful.test')).to eq true
      expect(File.exist? File.expand_path('~/.dutiful.test.ignored')).to eq false
    end
  end
end
