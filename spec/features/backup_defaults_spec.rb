require 'support/feature'

RSpec.describe 'Backup defaults:', if: Dutiful::Config.osx? do
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
    with_application defaults: 'com.dutiful test green' do
      expect {
        Dutiful::Command::Main.run 'dutiful', ['backup', '-q']
      }.to change { File.exist? "#{Dutiful::Config.storage.path}/defaults/com.dutiful/test" }.to true

      content = File.read("#{Dutiful::Config.storage.path}/defaults/com.dutiful/test")
      expect(content).to eq 'green'
    end
  end

  it 'backup multiple defaults' do
    with_application defaults: ['com.dutiful test green', 'com.dutiful test2 red'] do
      Dutiful::Command::Main.run 'dutiful', ['backup', '-q']

      content = File.read("#{Dutiful::Config.storage.path}/defaults/com.dutiful/test")
      expect(content).to eq 'green'

      content = File.read("#{Dutiful::Config.storage.path}/defaults/com.dutiful/test2")
      expect(content).to eq 'red'
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
