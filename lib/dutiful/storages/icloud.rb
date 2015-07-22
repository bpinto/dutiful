require 'fileutils'
require 'shellwords'

module Dutiful
  module Storage
    class Icloud
      PATH = ::File.expand_path("~/Library/Mobile Documents")

      def self.available?
        ::File.exist? PATH
      end

      def self.create_dir(file)
        directory_path = ::File.dirname "#{dir}/#{file.path}"
        `mkdir -p #{directory_path.shellescape}`
      end

      def self.dir
        "#{PATH}/dutiful"
      end

      def self.exist?(file)
        ::File.exist? "#{dir}/#{file.path}"
      end

      def self.name
        'iCloud'
      end

      def self.sync(file)
        create_dir file
        Rsync.run file.full_path.shellescape, "#{dir}/#{file.path}".shellescape
      end

      def self.synced?(file)
        FileUtils.identical? file.full_path, "#{dir}/#{file.path}"
      end
    end
  end
end
