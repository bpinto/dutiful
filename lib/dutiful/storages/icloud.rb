require 'fileutils'

module Dutiful
  module Storage
    class Icloud
      PATH = '~/Library/Mobile Documents'

      def self.available?
        ::File.exists? ::File.expand_path(PATH)
      end

      def self.dir
        "#{PATH}/dutiful"
      end

      def self.exists?(file)
        ::File.exists? ::File.expand_path("#{dir}/#{file.path}")
      end

      def self.name
        'iCloud'
      end

      def self.synced?(file)
        FileUtils.identical? file.full_path, ::File.expand_path("#{dir}/#{file.path}")
      end
    end
  end
end
