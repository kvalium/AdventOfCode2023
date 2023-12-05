#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'
require 'byebug'

def lines_to_maps(lines)
  maps = {}
  @invert_maps = {}
  while lines.any?
    map = []
    map_name = lines.shift.split.first
    map << lines.shift while lines.any? && !lines.first.empty?
    maps[map_name] = map_dict(map)
    @invert_maps[map_name] = map_dict_ranges(map)
    lines.shift
  end
  maps
end

def map_dict(map)
  dict = {}
  map.each do |line|
    dest_range_start, source_range_start, length = line.split.map(&:to_i)
    dict[(source_range_start..source_range_start + length - 1)] = dest_range_start
  end
  dict
end

def map_dict_ranges(map)
  dict = {}
  map.each do |line|
    dest_range_start, source_range_start, length = line.split.map(&:to_i)
    dict[(dest_range_start..dest_range_start + length)] = (source_range_start..source_range_start + length)
  end
  dict
end

def almanach_sequence
  @maps.keys
end

def location(seed)
  source = seed
  # puts '------------------'
  # puts "seed: #{seed}"
  almanach_sequence.each do |map_name|
    # pp "map: #{@maps[map_name]}"
    map = @maps[map_name]
    source_range = map.keys.find { |r| r.include?(source) }
    source_range_start_difference = source - source_range.first if source_range
    destination = map[source_range] ? map[source_range] + source_range_start_difference : source
    # puts "#{map_name} #{source} -> #{destination}"
    source = destination
  end
  source
end

def part_one(seeds)
  seeds.map { |seed| location(seed) }.min
end

def part_two(_seeds)
  puts "min_location_range: #{min_location_range_source}"
  puts "HUMIDITY matching keys: #{find_matching_ranges(min_location_range_source, 'temperature-to-humidity')}"
end

def min_location_range_source
  min_range = nil
  min_value = Float::INFINITY
  @maps[almanach_sequence.last].each_key do |range|
    if range.first < min_value
      min_range = range
      min_value = range.first
    end
  end

  source_start = @maps[almanach_sequence.last][min_range]
  (source_start..source_start + min_range.size - 1)
end

def find_matching_ranges(range, map_key)
  @invert_maps[map_key].keys.select { |r| r.cover?(range) }
end

Benchmark.bm do |x|
  x.report do
    lines = ARGF.read.lines.map(&:chomp)
    seeds = lines[0].split(': ')[1].split.map(&:to_i)
    @maps = lines_to_maps(lines[2..])
    # pp seeds
    # pp @maps
    puts "part one - min location: #{part_one(seeds)}"
  # puts "part two - - min location: #{part_two(seeds)}"
  end
end
