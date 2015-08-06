require 'support/feature'

RSpec.describe 'Backup defaults:' do
  it 'creates the dutiful folder' do
    with_application defaults: 'com.dutiful test green' do
      expect {
        Dutiful::Command::Main.run 'dutiful', ['backup', '-q']
      }.to change { Dir.exist? Dutiful::Config.storage.path }.to true
    end
  end

  it 'creates the necessary folders for backup' do
    with_application defaults: 'com.dutiful test green' do
      expect {
        Dutiful::Command::Main.run 'dutiful', ['backup', '-q']
      }.to change { Dir.exist? "#{Dutiful::Config.storage.path}/defaults/com.dutiful" }.to true
    end
  end

  it 'backup a single default' do
    content = nil

    with_application defaults: 'com.dutiful test green' do
      expect {
        Dutiful::Command::Main.run 'dutiful', ['backup', '-q']
      }.to change { File.exist? "#{Dutiful::Config.storage.path}/defaults/com.dutiful/test" }.to true

      File.open("#{Dutiful::Config.storage.path}/defaults/com.dutiful/test") { |file| content = file.read }
      expect(content.strip).to eq 'green'
    end
  end

  it 'backup multiple defaults' do
    content = nil

    with_application defaults: ['com.dutiful test green', 'com.dutiful test2 red'] do
      Dutiful::Command::Main.run 'dutiful', ['backup', '-q']

      File.open("#{Dutiful::Config.storage.path}/defaults/com.dutiful/test") { |file| content = file.read }
      expect(content.strip).to eq 'green'

      File.open("#{Dutiful::Config.storage.path}/defaults/com.dutiful/test2") { |file| content = file.read }
      expect(content.strip).to eq 'red'
    end
  end

  it 'does not backup if the default is not set' do
    with_application defaults: 'com.dutiful.does not exist' do
      `defaults delete com.dutiful.does`

      Dutiful::Command::Main.run 'dutiful', ['backup', '-q']
      expect(Dir.exist? "#{Dutiful::Config.storage.path}/defaults/com.dutiful.does").to eq false
    end
  end
end
