require "radio5"
require "net/http"
require "uri"
require "fileutils"
require "pathname"
require "thread"

# Constants
TOTAL_TRACKS = 1000000
MAX_THREADS = 100

# Create client
client = Radio5::Client.new

# Determine the directory of the current script
script_dir = Pathname.new(__FILE__).realpath.dirname

# Create "download_tracks" folder in the same directory
folder = script_dir.join("download_tracks")
FileUtils.mkdir_p(folder)

# Mutex to synchronize file writing
mutex = Mutex.new

# Queue to hold work items
queue = Queue.new
TOTAL_TRACKS.times { queue << true }

# Worker threads
threads = MAX_THREADS.times.map do |thread_id|
  Thread.new do
    loop do
      begin
        queue.pop(true)
      rescue ThreadError
        break  # Queue is empty, exit loop
      end

      begin
        puts "[Thread #{thread_id}] Fetching track..."

        track = client.random_track(decades: [1940, 1950, 1960, 1970], moods: [:slow, :weird])
        next unless track

        artist = track[:artist].to_s.strip
        title = track[:title].to_s.strip
        filename = "#{artist} - #{title}".gsub(/[\/:*?"<>|]/, "_") + ".mp3"
        filepath = folder.join(filename)

        # Skip if file already exists
        if filepath.exist?
          puts "[Thread #{thread_id}] Already exists: #{filename}, skipping."
          next
        end

        audio_url = track.dig(:audio, :mpeg, :url)
        unless audio_url
          puts "[Thread #{thread_id}] No audio URL for #{artist} - #{title}"
          next
        end

        response = Net::HTTP.get_response(URI(audio_url))
        audio_file = response.body

        mutex.synchronize do
          File.open(filepath, "wb") { |f| f << audio_file }
          puts "[Thread #{thread_id}] Saved: #{filename}"
        end
      rescue KeyError => e
        puts "[Thread #{thread_id}] Skipped due to missing key: #{e.message}"
      rescue StandardError => e
        puts "[Thread #{thread_id}] Error: #{e.message}"
      end
    end
  end
end

# Wait for all threads to finish
threads.each(&:join)

puts "All done! Tracks saved to: #{folder}"
