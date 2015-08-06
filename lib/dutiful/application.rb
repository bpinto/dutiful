class Dutiful::Application
  def initialize(path)
    @path = path
  end

  def defaults
    return [] unless Dutiful::Config.osx?

    Array(content[:default]).map { |default| Dutiful::ApplicationDefault.new default }
  end

  def files
    Array(content[:file]).map { |file| Dutiful::ApplicationFile.new file[:path], file[:condition] }
  end

  def name
    content[:application][:name]
  end

  def backup(&block)
    sync backup_only: true, &block
  end

  def restore(&block)
    sync restore_only: true, &block
  end

  def sync(backup_only: false, restore_only: false)
    files.each do |file|
      if file.should_sync?
        result = if backup_only && file.exist?
                   Dutiful::Config.storage.backup(file)
                 elsif restore_only && file.has_backup?
                   Dutiful::Config.storage.restore(file)
                 else
                   Dutiful::Config.storage.sync(file)
                 end

        yield file, result if block_given?
      else
        yield file if block_given?
      end
    end

    defaults.each do |default|
      if default.should_sync?
        result = if backup_only && default.exist?
                   default.backup
                 elsif restore_only && default.has_backup?
                   default.restore
                 else
                   default.sync
                 end

        yield default, result if block_given?
      else
        yield default if block_given?
      end
    end
  end

  def exist?
    files.any?(&:exist?) || defaults.any?(&:exist?)
  end

  def has_backup?
    files.any?(&:has_backup?) || defaults.any?(&:has_backup?)
  end

  def should_sync?
    exist? || has_backup?
  end

  def synced?
    files.all?(&:synced?) || defaults.any?(&:synced?)
  end

  def self.all
    Dir["#{Dutiful.dir}/db/*.toml"].map do |filename|
      Dutiful::Application.new filename
    end.compact
  end

  def self.each
    return enum_for(:each) unless block_given?

    all.each { |application| yield application }
  end

  private

  def content
    @content ||= Tomlrb.load_file(@path, symbolize_keys: true)
  end
end
