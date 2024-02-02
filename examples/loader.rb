# frozen_string_literal: true

require "radio5"
require "slop"
require "colorize"
require "fileutils"
require "json"
require "set"

##
# Universal tracks loader
#
# Setup (additional gems):
#   gem install slop
#   gem install colorize
#
# Usage:
#   load random tracks
#     ruby loader.rb
#
#   load tracks using filters
#     ruby loader.rb -c FRA -d 1960,1980,1990 -m weird,slow
#
# All opts:
#   ruby loader.rb -h
#

DEFAULT_OPTS = {
  folder_path: "~/Downloads/radio5_music",
  track_limit: 100,
  unique_tracks: true,
  audio_format: :mpeg
}

AUDIO_FORMATS = %i[mpeg ogg]

class Loader
  class TrackNotFound < StandardError
  end

  TRACKS_SUBFOLDER = "tracks"
  CATALOG_FILENAME = "catalog.txt"
  MAX_RETRIES = 3

  LOG_STATUSES = {
    new: "OK".light_yellow,
    exists: "-/-".light_black,
    missing: "missing".light_blue
  }

  attr_reader :opts, :client, :track_count, :catalog

  def initialize(opts)
    @opts = opts
    @client = Radio5::Client.new
    @track_count = 0

    init_folders!

    @catalog = Catalog.new(paths[:catalog])
  end

  def start
    loop do
      break if track_count >= opts[:track_limit]

      track = get_track

      if catalog.include?(track)
        if opts.unique_tracks?
          log(:exists, track)
          next
        end

        @track_count += 1

        if File.file?(track.filepath)
          log(:exists, track)
        else
          track_file = download_file(track.audio_url)
          save_file(track.filepath, track_file)

          log(:missing, track)
        end
      else
        @track_count += 1

        track_file = download_file(track.audio_url)
        save_file(track.filepath, track_file)
        catalog.add_track(track)

        log(:new, track)
      end
    end
  end

  def search_params
    @search_params ||= {
      country: opts[:country],
      decades: opts[:decades].map(&:to_i),
      moods: opts[:moods].empty? ? nil : opts[:moods].map(&:to_sym)
    }.compact
  end

  def get_track
    track_data = client.random_track(**search_params)

    if track_data.nil?
      raise TrackNotFound, "search params: #{search_params}"
    end

    Track.new(track_data, opts[:audio_format], paths[:tracks])
  end

  def init_folders!
    FileUtils.mkdir_p(paths[:tracks]) # main folder created automatically
  end

  def paths
    @paths ||= begin
      main = File.expand_path(opts[:folder_path])

      {
        main: main,
        tracks: File.join(main, TRACKS_SUBFOLDER),
        catalog: File.join(main, CATALOG_FILENAME)
      }
    end
  end

  def download_file(url, retries: 0)
    uri = URI(url)
    Net::HTTP.get_response(uri).body
  rescue => error
    if retries < MAX_RETRIES
      download_file(url, retries: retries + 1)
    else
      raise error
    end
  end

  def save_file(path, file)
    File.open(path, "wb") { |f| f << file }
  end

  def log(status, track)
    main_string = "[#{track_count}/#{opts[:track_limit]}] #{track[:artist]} - #{track[:title]} (#{track[:id]})"
    status_string = LOG_STATUSES.fetch(status)

    puts "#{main_string} | #{status_string}"
  end
end

class Catalog
  attr_reader :file, :track_ids

  def initialize(catalog_path)
    @file = File.open(catalog_path, "a+")
    @track_ids = Set.new(file.read.split("\n"))
  end

  def include?(track)
    track_ids.include?(track[:id])
  end

  def add_track(track)
    track_ids << track[:id]
    file << track[:id] << "\n"
  end
end

class Track
  FILENAME_PATTERN = "%<artist>s - %<title>s (%<album>s, %<year>s) [%<country>s, %<decade>s, %<mood>s] (%<id>s).%<file_format>s"

  attr_reader :data, :audio_format, :tracks_folder

  def initialize(data, audio_format, tracks_folder)
    @data = data
    @audio_format = audio_format
    @tracks_folder = tracks_folder
  end

  def [](key)
    data[key]
  end

  def audio_url
    @audio_url ||= data.dig(:audio, audio_format, :url) do
      raise KeyError, "URL not found, format: #{audio_format.inspect}, track data: #{data.inspect}"
    end
  end

  def file_format
    @file_format ||= audio_url[/(?<=\.)[[:alnum:]]+(?=\?)/]
  end

  def filename
    @filename ||= begin
      raw_filename = FILENAME_PATTERN % data.merge(file_format: file_format)
      sanitize_filename(raw_filename)
    end
  end

  def filepath
    @filepath ||= File.join(tracks_folder, filename)
  end

  private

  def sanitize_filename(filename)
    filename
      .encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "�")
      .strip
      .tr("\u{202E}%$|:;/\t\r\n\\", "-")
  end
end

# rubocop:disable Layout/ExtraSpacing
if __FILE__ == $0
  opts = Slop.parse do |o|
    o.string  "-c", "--country", "country ISO code, e.g. FRA"
    o.array   "-d", "--decades", "decades, e.g. 1980,1990"
    o.array   "-m", "--moods", "moods, e.g. weird,slow"
    o.string  "-f", "--folder-path", "path to folder to store files, default: #{DEFAULT_OPTS[:folder_path]}", default: DEFAULT_OPTS[:folder_path]
    o.integer "-l", "--track-limit", "number of tracks to download, default: #{DEFAULT_OPTS[:track_limit]}", default: DEFAULT_OPTS[:track_limit]
    o.bool    "-u", "--unique-tracks", "skip tracks that were downloaded previously, default: #{DEFAULT_OPTS[:unique_tracks]}", default: DEFAULT_OPTS[:unique_tracks]
    o.symbol  "-a", "--audio-format", "audio format to download, i.e. `mpeg` or `ogg`, default: #{DEFAULT_OPTS[:audio_format]}", default: DEFAULT_OPTS[:audio_format]

    o.on "-h", "--help" do
      puts o
      exit
    end
  end

  unless AUDIO_FORMATS.include?(opts[:audio_format])
    raise ArgumentError, "incorrect audio format: #{opts[:audio_format].inspect}"
  end

  loader = Loader.new(opts)
  loader.start
end
# rubocop:enable Layout/ExtraSpacing
