require "bundler/setup"

require "image_sorcery"
require "image_squeeze"
require "colorize"
require "hashugar"

require 'ostruct'
require 'yaml'

class ImageSqueeze
  class PNGCrushSilentProcessor < PNGCrushProcessor
    def self.squeeze(filename, output_filename)
      system("pngcrush -rem alla -brute -reduce #{filename} #{output_filename} > /dev/null 2>&1")
    end
  end
end

# load config and init
config = YAML.load_file(File.join(Dir.pwd, "logo_definitions.yml")).to_hashugar
full_output_path = File.join(Dir.pwd, config.defaults.output_folder)
created_files = []

# create output folder
system "mkdir -p #{full_output_path}"

# clean output folder
system "rm -rf #{File.join(full_output_path, '*')}"

# create assets
config.definitions.each do |definition|

  image = ImageSorcery.new(File.join(config.defaults.template_folder, definition.template))

  definition.formats.each do |label, settings|
    logo_file_name = "#{definition.logo_name}_#{label}.#{settings.format}"
    logo_full_path = File.join(Dir.pwd, config.defaults.output_folder, logo_file_name)
    image.convert(logo_full_path, format: settings.format, resize: settings.size, depth: config.defaults.depth, colors: config.defaults.colors)
    puts "Created #{logo_file_name}".green
    created_files << logo_full_path
  end
end

# reduce file size
squeezer = ImageSqueeze.new(processors: [ ImageSqueeze::PNGCrushSilentProcessor ])

created_files.each do |file|
  squeezer.squeeze!(file)
  puts "Squeezed #{file}".green
end

# open result folder
if config.defaults.open_when_done
  puts "Opening result folder".green
  system "open #{full_output_path}"
end

