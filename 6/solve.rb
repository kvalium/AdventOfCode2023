#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'

def race_times(race_time, best_distance)
  (1..race_time).map do |speed|
    remaining_distance = race_time - speed
    result = speed * remaining_distance
    is_winning = result > best_distance
    { speed: speed, result: result, is_winning: is_winning }
  end
end

def races(lines)
  times, records = lines.map { _1.scan(/\d+/).map(&:to_i) }
  times.zip(records)
end

def part_one(races)
  races.reduce(1) do |acc, race|
    acc * race_times(*race).select { _1[:is_winning] }.count
  end
end

Benchmark.bm do |x|
  x.report do
    lines = ARGF.read.lines.map(&:chomp)
    races = races(lines)
    puts "part one - #{part_one(races)}"
  end
end
