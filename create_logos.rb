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
squeezer = ImageSqueeze.new(processors: [ ImageSqueeze::PNGCrushSilentProcessor ])

full_output_path = File.join(Dir.pwd, config.defaults.output_folder)

# create output folder
system "mkdir -p #{full_output_path}"

# clean output folder
system "rm -rf #{File.join(full_output_path, '*')}"


headline = " +  toy rocket science - branding  +"
puts "\n " + ("=" * headline.length)
puts  headline
puts " " + ("=" * headline.length) + "\n"

# create assets
config.assets.each do |set_name, definition|

  print "\n PROCESSING "
  puts  "#{set_name}\n".yellow

  image = ImageSorcery.new(File.join(config.defaults.template_folder, definition.template))

  definition.versions.each do |label, settings|
    logo_file_name = "#{definition.logo_name}_#{label}.#{config.defaults.format}"
    logo_full_path = File.join(Dir.pwd, config.defaults.output_folder, logo_file_name)

    convert_settings = {
      define: "png:include-chunk=none,trns,gama",
      format: "png",
      resize: settings.size,
      depth: config.defaults.depth,
      colors: config.defaults.colors,
      dither: 'None',
      strip: true,
      background: config.defaults.background
    }
    image.convert(logo_full_path, convert_settings)

    print " CREATED    ".green
    puts logo_file_name #.white

    # reduce file size
    squeezer.squeeze!(logo_full_path)

    print " SQUEEZED   ".green
    puts logo_file_name
    puts "\n"
  end
end

# open result folder
if config.defaults.open_when_done
  puts "\nOPENING result folder"
  system "open #{full_output_path}"
end

