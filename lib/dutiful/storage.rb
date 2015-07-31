require 'fileutils'
require 'shellwords'

class Dutiful::Storage
  attr_reader :name, :storage_path

  def initialize(name: nil, path: nil)
    name ||= 'Custom folder'
    path ||= Tomlrb.load_file("config/#{name.downcase}.toml", symbolize_keys: true)[:storage][:path]

    @name         = name
    @storage_path = File.expand_path path
    @path         = "#{@storage_path}/dutiful"
  end

  def available?
    File.exist? storage_path
  end

  def create_dir(file)
    FileUtils.mkdir_p File.dirname "#{path}/#{file.path}".shellescape
  end

  def exist?(file)
    File.exist? "#{path}/#{file.path}"
  end

  def path(path = nil)
    if path
      "#{@path}/#{path}"
    else
      @path
    end
  end

  def sync(file)
    create_dir file

    if file.exist?
      if file.has_backup? && file.backup_timestamp > file.timestamp
        Rsync.run file.backup_path.shellescape, file.full_path.shellescape
      else
        Rsync.run file.full_path.shellescape, file.backup_path.shellescape
      end
    else
      Rsync.run file.backup_path.shellescape, file.full_path.shellescape
    end
  end

  def synced?(file)
    FileUtils.identical? file.full_path, "#{path}/#{file.path}"
  end

  private

  def self.all
    Dir['config/*.toml'].map do |filename|
      data = Tomlrb.load_file(filename, symbolize_keys: true)[:storage]
      Dutiful::Storage.new name: data[:name], path: data[:path]
    end.compact
  end

  def self.each
    return enum_for(:each) unless block_given?

    all.each { |storage| yield storage }
  end

  def self.find(if_none = nil, &block)
    result = nil
    found  = false

    each do |element|
      if block.call(element)
        result = element
        found = true
        break
      end
    end

    found ? result : if_none && if_none.call
  end
end
