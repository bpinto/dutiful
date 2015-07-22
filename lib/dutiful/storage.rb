require 'fileutils'
require 'shellwords'

class Dutiful::Storage
  attr_reader :content, :full_path, :path

  def initialize(path)
    @content = Tomlrb.load_file(path, symbolize_keys: true)[:storage]
  end

  def available?
    ::File.exist? path
  end

  def create_dir(file)
    file_directory_path = ::File.dirname "#{dutiful_path}/#{file.path}"
    `mkdir -p #{file_directory_path.shellescape}`
  end

  def dutiful_path
    "#{path}/dutiful"
  end

  def exist?(file)
    ::File.exist? "#{dutiful_path}/#{file.path}"
  end

  def name
    content[:name]
  end

  def path
    @path ||= ::File.expand_path content[:path]
  end

  def sync(file)
    create_dir file
    Rsync.run file.full_path.shellescape, "#{dutiful_path}/#{file.path}".shellescape
  end

  def synced?(file)
    FileUtils.identical? file.full_path, "#{dutiful_path}/#{file.path}"
  end

  private

  def self.all
    Dir.foreach('config').map do |filename|
      next if filename == '.' or filename == '..'

      Dutiful::Storage.new "config/#{filename}"
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
