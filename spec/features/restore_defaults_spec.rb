require 'support/feature'

RSpec.describe 'Restore defaults:', if: Dutiful::Config.osx? do
  it 'restores a single default' do
    content = nil

    with_application backup_defaults: 'com.dutiful test green' do
      Dutiful::Command::Main.run 'dutiful', ['restore', '-q']
      expect(`defaults read com.dutiful test`.strip).to eq 'green'
    end
  end

  it 'backup multiple defaults' do
    with_application backup_defaults: ['com.dutiful test green', 'com.dutiful test2 red'] do
      Dutiful::Command::Main.run 'dutiful', ['restore', '-q']
      expect(`defaults read com.dutiful test`.strip).to eq 'green'
      expect(`defaults read com.dutiful test2`.strip).to eq 'red'
    end
  end
end
