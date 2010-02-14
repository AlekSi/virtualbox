module VirtualBox
  # Represents the VirtualBox main configuration file (VirtualBox.xml)
  # which VirtualBox uses to keep track of all known virtual machines
  # and images.
  class Global < AbstractModel
    # TODO: Add Windows support.
    ["~/Library/VirtualBox/VirtualBox.xml", "~/.VirtualBox/VirtualBox.xml"].each do |file|
      file = File.expand_path(file)
      @@vboxconfig = file if File.exist?(file)
    end

    relationship :vms, VM, :lazy => true
    relationship :media, Media
    relationship :extra_data, ExtraData

    @@global_data = nil

    class <<self
      def global(reload = false)
        if !@@global_data || reload
          @@global_data = new(config)
        end

        @@global_data
      end

      # Sets the path to the VirtualBox.xml file. This file should already
      # exist. VirtualBox itself manages this file, not this library.
      #
      # @param [String] Full path to the VirtualBox.xml file
      def vboxconfig=(value)
        @@vboxconfig = value
      end

      # Returns the XML document of the configuration.
      #
      # @return [Nokogiri::XML::Document]
      def config
        Command.parse_xml(File.expand_path(@@vboxconfig))
      end

      # Expands path relative to the configuration file.
      #
      # @return [String]
      def expand_path(path)
        File.expand_path(path, File.dirname(@@vboxconfig))
      end
    end

    def initialize(document)
      @document = document
      populate_attributes(@document)
    end

    def load_relationship(name)
      populate_relationship(:vms, @document)
    end
  end
end