# Radio5

[![Gem Version](https://badge.fury.io/rb/radio5.svg)](https://badge.fury.io/rb/radio5)
[![Build](https://github.com/ocvit/radio5/workflows/Build/badge.svg)](https://github.com/ocvit/radio5/actions)
[![Coverage Status](https://coveralls.io/repos/github/ocvit/radio5/badge.svg?branch=main)](https://coveralls.io/github/ocvit/radio5?branch=main)

Adapter for [Radiooooo](https://radiooooo.com/) private API.

For music exploration purposes only 🧐

## TL;DR

It turned out that 95% of all functionality doesn't even require an account (I'm not even talking about premium one), so here we go.

## Installation

Install the gem and add to Gemfile:

```sh
bundle add radio5
```

Or install it manually:

```sh
gem install radio5
```

## Configuration

Create a client:

```ruby
client = Radio5::Client.new
```

You can pass additional HTTP configration if needed:

```ruby
client = Radio5::Client.new(
  open_timeout: 30, # default: 10
  read_timeout: 30, # default: 10
  write_timeout: 30, # default: 10
  proxy_url: "http://user:pass@123.4.56.178:80", # default: nil
  debug_output: $stdout # default: nil
)
```

## Usage

To get random track:

```ruby
client.random_track
# => {
#   id: "655f7bb24b0d722a021a2cf2",
#   uuid: <uuid>,
#   artist: "Kaye Ballard",
#   title: "In Other Words (Fly Me to the Moon)",
#   album: "In Other Words / Lazy Afternoon",
#   year: "1954",
#   label: "Decca",
#   songwriter: "Bart Howard",
#   length: 133,
#   info: "It is the original recording of Fly me to the moon !",
#   cover_url: "https://asset.radiooooo.com/cover/USA/1950/large/<uuid>_1.jpg",
#   audio: {
#     mpeg: {
#       url: "https://radiooooo-track.b-cdn.net/USA/1950/<uuid>.mp3?token=<token>&expires=1704717060",
#       expires_at: 2024-01-08 12:31:00 UTC
#     },
#     ogg: {
#       url: "https://radiooooo-track.b-cdn.net/USA/1950/<uuid>.ogg?token=<token>&expires=1704717060",
#       expires_at: 2024-01-08 12:31:00 UTC
#     }
#   },
#   decade: 1950,
#   mood: :slow,
#   country: "USA",
#   like_count: 3,
#   created_at: nil,
#   created_by: "655ec7fce03fdc024c70f698"
# }
#
# NOTES:
# - `created_at` - always nil here (API limitations), available via `#track` if needed
# - `created_by` - `id` of user who uploaded this track
```

To get random track using additional filters:

```ruby
# with country
client.random_track(country: "FRA")

# with decade(s)
client.random_track(decades: [1960, 2000])

# with mood(s)
client.random_track(moods: [:slow, :weird])

# with everything together
client.random_track(country: "SWE", decades: [1940, 1980, 2010], moods: [:slow, :fast])

# in case no tracks match the filters
client.random_track(country: "KN1", decades: [1940], moods: [:weird])
# => nil
```

To get information about specific track using its `id`:

```ruby
client.track("655f7bb24b0d722a021a2cf2")
# => {
#   ...
#   created_at: 2023-11-23 16:20:02.283 UTC
# }
#
# output is exactly the same as from `#random_track`, but `created_at` is now filled
```

OK, what input parameters are available?

```ruby
# list of countries + additional info:
#   - `exist` - "is it still around" flag
#   - `rank`  - subjective ranking provided by the website, only 10 countries have it
client.countries
# => {
#   "AFG" => {name: "Afganistan", exist: true, rank: nil},
#   "CBE" => {name: "Belgian Congo", exist: false, rank: nil},
#   "FRA" => {name: "France", exist: true, rank: 2},
#   ...
# }

# decades
client.decades
# => [1900, 1910, 1920, ..., 2010, 2020]

# moods
client.moods
# => [:fast, :slow, :weird]
#
# NOTE: by default all 3 moods are used in `#random_track` and `#island_track`
```

It's also possible to get all valid `country`/`decade`/`moods` combinations in advance:

```ruby
# grouped by country
client.countries_for_decade(1960)
# => {
#   "THA" => [:fast, :slow, :weird],
#   "TWN" => [:fast, :slow, :weird],
#   "EST" => [:fast, :slow],
#   "ALB" => [:fast, :slow],
#   "NZL" => [:fast, :slow],
#   ...
# }

# grouped by mood
client.countries_for_decade(1960, group_by: :mood)
# => {
#   slow: ["FRA", "THA", "ALB", "GRC", "IRL", ...],
#   fast: ["THA", "TWN", "EST", "ALB", "NZL", ...],
#   weird: ["AZE", "POL", "IRN", "YUG", "DAH", ...]
# }
```

How to work with the "islands" ("playlists" in the simple words):

```ruby
# list all islands
client.islands
# => [{
#   id: "5d330a3e06fb03d8872a3316",
#   uuid: <uuid>,
#   api_id: <api_id>,
#   name: "Intimacy",
#   info: "To get Laid. Slow to start. Fast to go further. Weird when nothing works.",
#   category: "thematic",
#   favourite_count: 1,
#   play_count: 783339,
#   rank: 17,
#   icon_url: "https://asset.radiooooo.com/island/icon/<uuid>_2.svg",
#   splash_url: "https://asset.radiooooo.com/island/splash/<uuid>_13.svg",
#   marker_url: "https://asset.radiooooo.com/island/marker/<uuid>_9.svg",
#   enabled: true,
#   free: false,
#   on_map: false,
#   random: false,
#   play_mode: "RANDOM",
#   created_at: 2016-02-12 16:31:00 UTC,
#   created_by: "5d3306de06fb03d8871fd119",
#   updated_at: 2023-02-17 15:54:09.806 UTC,
#   updated_by: "5d3306de06fb03d8871fd119"
# }, ...]
#
# NOTES:
#   - `api_id`     - have no idea where it is used
#   - `rank`       - 1..160, not unique, can be nil
#   - `enabled`    - is it searchable via web app, doesn't matter in our case ^^
#   - `free`       - do you need premium account to listen to it, doesn't matter ^^
#   - `on_map`     - is it displayed on a global map currently
#   - `random`     - there is only one playlist with `true` and it's called "Shuffle";
#                    basically the same as `#random_track` with no filters
#   - `play_mode`  - it is somehow used in a web app
#   - `created_by` - `id` of user who created this island
#   - `updated_by` - ...and who updated it last time

# to get random track from selected island
client.island_track(island_id: "5d330a3e06fb03d8872a3316")

# it's also possible to specify moods
client.island_track(island_id: "5d330a3e06fb03d8872a3316", moods: [:fast, :weird])
```

User endpoints - WIP.

## Auth?

There is just a couple of features that require login and/or premium account:

- history of "listened" tracks - track becomes "listened" when you got it via `#random_track` or `#island_track` (free)
- `followed` flag for `#user` - indicates whether or not you follow this user (free)
- `#user_liked_tracks` - list of tracks which user really rock'n'roll'ed to (free)
- ability to use multiple countries as a filter in `#random_track` (premium)

Currently auth is in a WIP state.

## TODO

- [x] HTTP client (no external deps, net/http hardcore only)  
- [x] Basic API client (no auth)  
- [x] Countries support  
- [x] Islands support  
- [x] Tracks support  
- [ ] Users support  
- [ ] Auth + auth'ed endpoints  

## Development

```sh
bin/setup     // install deps
bin/console   // interactive prompt to play around
rake spec     // test!
rake rubocop  // lint!
sudo rm -rf / // relax, just kidding ^^
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ocvit/radio5.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
