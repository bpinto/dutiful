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
    (files + defaults).each do |file|
      if file.exist?
        yield file, file.backup if block_given?
      else
        yield file if block_given?
      end
    end
  end

  def restore(&block)
    (files + defaults).each do |file|
      if file.has_backup?
        yield file, file.restore if block_given?
      else
        yield file if block_given?
      end
    end
  end

  def exist?
    files.any?(&:exist?) || defaults.any?(&:exist?)
  end

  def has_backup?
    files.any?(&:has_backup?) || defaults.any?(&:has_backup?)
  end

  def tracked?
    exist? || has_backup?
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
