# frozen_string_literal: true

require "radio5"

# create client
client = Radio5::Client.new

# load info about random track
track = client.random_track

# load track audio file
audio_url = track.dig(:audio, :mpeg, :url)
audio_file = Net::HTTP.get_response(URI(audio_url)).body

# save audio file to specified folder
folder = File.expand_path("~/Downloads")
File.open("#{folder}/track.mp3", "wb") { |f| f << audio_file }
