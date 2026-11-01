# Run with ruby script/build_site_icons.rb. Requires ImageMagick 7 for artwork
# resizing only; neither Rails nor production needs ImageMagick.
require "pathname"

root = Pathname.new(__dir__).parent
source = root.join("app/assets/images/legion-emblem.png")
public_dir = root.join("public")
{ "favicon-96x96.png" => 96, "apple-touch-icon.png" => 180,
  "icon-192.png" => 192, "icon.png" => 512 }.each do |name, size|
  # Keep the complete official artwork in proportion, including its perimeter.
  artwork_size = (size * 0.88).round
  system("magick", source.to_s, "-resize", "#{artwork_size}x#{artwork_size}",
    "-background", "white", "-alpha", "remove", "-alpha", "off",
    "-gravity", "center", "-extent", "#{size}x#{size}", "-strip",
    public_dir.join(name).to_s, exception: true)
end
system("magick", public_dir.join("icon.png").to_s, "-define", "icon:auto-resize=48,32,16",
  public_dir.join("favicon.ico").to_s, exception: true)
