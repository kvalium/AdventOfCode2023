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

def times_and_records(lines)
  lines.map { _1.scan(/\d+/).map(&:to_i) }
end

def races(lines)
  times, records = times_and_records(lines)
  times.zip(records)
end

def part_one(races)
  races.reduce(1) do |acc, race|
    acc * race_times(*race).select { _1[:is_winning] }.count
  end
end

def part_two(lines)
  final_race = times_and_records(lines).map(&:join).map(&:to_i)
  part_one([final_race])
end

Benchmark.bm do |x|
  x.report do
    lines = ARGF.read.lines.map(&:chomp)
    races = races(lines)
    puts "part one - #{part_one(races)}"
    puts "part two - #{part_two(lines)}"
  end
end
