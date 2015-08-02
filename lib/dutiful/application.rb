class Dutiful::Application
  def initialize(path)
    @path = path
  end

  def files
    content[:file].map { |file| Dutiful::ApplicationFile.new file[:path], file[:condition] }
  end

  def name
    content[:application][:name]
  end

  def backup
    files.each do |file|
      if file.should_sync? && file.exist?
        result = Dutiful::Config.storage.backup(file)
        yield file, result if block_given?
      else
        yield file if block_given?
      end
    end
  end

  def restore
    files.each do |file|
      if file.should_sync? && file.has_backup?
        result = Dutiful::Config.storage.restore(file)
        yield file, result if block_given?
      else
        yield file if block_given?
      end
    end
  end

  def sync
    files.each do |file|
      if file.should_sync?
        result = Dutiful::Config.storage.sync(file)
        yield file, result if block_given?
      else
        yield file if block_given?
      end
    end
  end

  def exist?
    files.any? &:exist?
  end

  def has_backup?
    files.any? &:has_backup?
  end

  def should_sync?
    exist? || has_backup?
  end

  def synced?
    files.all? &:synced?
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
