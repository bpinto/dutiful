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

  def with_application(name = 'test_application', options)
    files        = Array(options[:files]).map        { |file| create_file(file) }
    backup_files = Array(options[:backup_files]).map { |file| create_file(file) }

    defaults        = Array(options[:defaults]).map        { |default| create_default(default) }
    backup_defaults = Array(options[:backup_defaults]).map { |default| create_default(default) }

    create_application_toml(name, files + backup_files, defaults + backup_defaults)

    files.each do |file|
      FileUtils.mkdir_p File.dirname(file[:expanded_path])
      File.open(file[:expanded_path], 'w') { |file| file << 'file test content' }
    end

    backup_files.each do |file|
      FileUtils.mkdir_p File.dirname(file[:backup_path])
      File.open(file[:backup_path], 'w') { |file| file << 'file test content' }
    end

    defaults.each do |default|
      `defaults write #{default[:domain]} #{default[:key]} '#{default[:value]}'`
    end

    backup_defaults.each do |default|
      FileUtils.mkdir_p File.dirname(default[:backup_path])
      File.open(default[:backup_path], 'w') { |file| file << default[:value] }
    end

    yield

  ensure
    (files + backup_files).each do |file|
      File.delete file[:backup_path]   if File.exist? file[:backup_path]
      File.delete file[:expanded_path] if File.exist? file[:expanded_path]
    end

    (defaults + backup_defaults).each { |default| `defaults delete #{default[:domain]} 2>/dev/null` }
  end

  private

  def create_application_toml(name, files, defaults)
    File.open("#{Dutiful.dir}/db/#{name}.toml", 'w') do |application|
      application << <<-EOF.gsub(/^ {6}/, '')
          [application]
          name = '#{name}'
      EOF

      files.each do |file|
        application << <<-EOF.gsub(/^ {8}/, '')

          [[file]]
          path = '#{file[:path]}'
        EOF

        if file[:condition]
          application << <<-EOF.gsub(/^ {10}/, '')
              [file.condition]
                command         = '#{file[:condition][:command]}'
                expected_status = #{file[:condition][:expected_status]}
          EOF
        end
      end

      defaults.each do |default|
        application << <<-EOF.gsub(/^ {8}/, '')

          [[default]]
          description = '#{name} description'
          domain      = '#{default[:domain]}'
          key         = '#{default[:key]}'
        EOF
      end
    end
  end

  def create_default(default)
    domain, key, value = default.split
    {
      backup_path: "#{Dutiful::Config.storage.path}/defaults/#{domain}/#{key}",
      domain: domain,
      key: key,
      value: value || 'default test content'
    }
  end

  def create_file(path)
    file = if path.is_a? Hash
      path
    else
      file = { path: path }
    end

    file[:backup_path]   = File.expand_path "#{Dutiful::Config.storage.path}/#{file[:path]}"
    file[:expanded_path] = File.expand_path "~/#{file[:path]}"

    file
  end
end
