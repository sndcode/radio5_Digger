require "radio5"
require "net/http"
require "uri"
require "fileutils"
require "pathname"

# Create client
client = Radio5::Client.new

# Determine the directory of the current script
script_dir = Pathname.new(__FILE__).realpath.dirname

# Create "download_tracks" folder in the same directory
folder = script_dir.join("download_tracks")
FileUtils.mkdir_p(folder)

# Download 1000 tracks with filters
1000.times do |i|
  puts "Downloading track #{i + 1} of 1000..."

  # Fetch a random track with filters
  begin
    track = client.random_track(decades: [1940, 1950, 1960, 1970], moods: [:slow, :weird])
  rescue KeyError => e
    puts "Skipped track due to missing key: #{e.message}"
    next
  rescue StandardError => e
    puts "Unexpected error fetching track: #{e.message}"
    next
  end

  # Skip if no track found
  unless track
    puts "No track found for the given filters."
    next
  end

  artist = track[:artist].to_s.strip
  title = track[:title].to_s.strip

  # Build a safe filename
  filename = "#{artist} - #{title}".gsub(/[\/:*?\"<>|]/, "_") + ".mp3"
  filepath = folder.join(filename)

  # Fetch and save the audio
  audio_url = track.dig(:audio, :mpeg, :url)

  if audio_url
    begin
      audio_file = Net::HTTP.get_response(URI(audio_url)).body
      File.open(filepath, "wb") { |f| f << audio_file }
      puts "Saved: #{filename}"
    rescue StandardError => e
      puts "Failed to download #{filename}: #{e.message}"
    end
  else
    puts "No audio URL for #{artist} - #{title}"
  end
end

puts "All done! Tracks saved to: #{folder}"
