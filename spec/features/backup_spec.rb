require 'support/feature'

RSpec.describe 'Backup' do
  it 'creates the dutiful folder' do
    with_application files: '.dutiful.test' do
      expect {
        Dutiful::Command::Main.run 'dutiful', ['backup', '-q']
      }.to change { Dir.exist? Dutiful::Config.storage.path }.to true
    end
  end

  it 'creates the necessary folders for backup' do
    with_application files: 'dutiful-test-folder/.dutiful.test' do
      expect {
        Dutiful::Command::Main.run 'dutiful', ['backup', '-q']
      }.to change { Dir.exist? "#{Dutiful::Config.storage.path}/dutiful-test-folder" }.to true
    end

    FileUtils.remove_entry File.expand_path('~/dutiful-test-folder')
  end

  it 'all files' do
    with_application files: '.dutiful.test' do
      expect {
        Dutiful::Command::Main.run 'dutiful', ['backup', '-q']
      }.to change { File.exist? "#{Dutiful::Config.storage.path}/.dutiful.test" }.to true
    end
  end

  it 'all files that meet the conditions' do
    file = {
      path: '.dutiful.test',
      condition: { command: 'true', expected_status: 0 }
    }

    ignored_file = {
      path: '.dutiful.test.ignored',
      condition: { command: 'false', expected_status: 0 }
    }

    with_application files: [file, ignored_file] do
      Dutiful::Command::Main.run 'dutiful', ['backup', '-q']
      expect(File.exist? "#{Dutiful::Config.storage.path}/.dutiful.test").to eq true
      expect(File.exist? "#{Dutiful::Config.storage.path}/.dutiful.test.ignored").to eq false
    end
  end
end
