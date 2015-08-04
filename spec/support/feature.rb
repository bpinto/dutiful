require 'tmpdir'

RSpec.configure do |config|
  config.before(:each) do
    dutiful_path          = Dir.mktmpdir('dutiful_test_path')
    dutiful_database_path = "#{dutiful_path}/db"
    dutiful_storage_path  = Dir.mktmpdir('dutiful_test_storage')

    FileUtils.mkdir dutiful_database_path

    allow(Dutiful::Config).to receive(:storage) { Dutiful::Storage.new name: 'test', path: dutiful_storage_path }
    allow(Dutiful).to receive(:dir) { dutiful_path }
  end

  config.after(:each) do
    FileUtils.remove_entry Dutiful.dir
    FileUtils.remove_entry Dutiful::Config.storage.storage_path
  end

  def with_application(name: 'test_application', files:)
    files = Array(files)

    File.open("#{Dutiful.dir}/db/#{name}.toml", 'w') do |application|
      application << <<-EOF.gsub(/^ {8}/, '')
          [application]
          name = '#{name}'
      EOF

      files.each do |file|
        if file.is_a? String
          application << <<-EOF.gsub(/^ {8}/, '')

            [[file]]
            path = '#{file}'
          EOF
        else
          application << <<-EOF.gsub(/^ {8}/, '')

            [[file]]
            path = '#{file[:path]}'

              [file.condition]
                command         = '#{file[:condition][:command]}'
                expected_status = #{file[:condition][:expected_status]}
          EOF
        end
      end
    end

    files.each do |file|
      filepath = (file.is_a? String) ? file : file[:path]

      FileUtils.mkdir_p File.dirname(File.expand_path "~/#{filepath}")
      File.open(File.expand_path("~/#{filepath}"), 'w') { |file| file << 'file test content' }
    end

    yield

  ensure
    files.each do |file|
      filepath = (file.is_a? String) ? file : file[:path]

      File.delete File.expand_path("~/#{filepath}") if File.exist? File.expand_path("~/#{filepath}")
    end
  end
end
