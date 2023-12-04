#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'

MAX_VALUES = {
  "red": 12,
  "green": 13,
  "blue": 14
}.freeze

def part_one(lines)
  possible_games = []
  lines.each do |line|
    game_possible = true
    game_id, game_results = games(line)

    game_results.each_with_index do |game_result, index|
      result = game_result.chomp.split(', ')
      result.each do |r|
        number, color = color_number(r)
        next unless number > MAX_VALUES[color.to_sym]

        game_possible = false
        break
      end
      possible_games << game_id if game_possible && index == game_results.size - 1
    end
  end
  puts "Possible games: #{possible_games.join(', ')} sum: #{possible_games.sum}"
end

def part_two(lines)
  acc = 0
  lines.each do |line|
    game_min_cubes = { red: 0, green: 0, blue: 0 }
    _game_id, game_results = games(line)
    game_results.each_with_index do |game_result, _index|
      result = game_result.chomp.split(', ')
      result.each do |r|
        number, color = color_number(r)
        game_min_cubes[color.to_sym] = [game_min_cubes[color.to_sym], number].max
      end
    end
    acc += game_min_cubes.values.reject(&:zero?).inject(:*)
  end
  puts 'acc: ', acc
end

def games(line)
  game = line.split(': ')
  game_id = game[0].split('Game ')[1].to_i
  game_results = game[1].split('; ')
  [game_id, game_results]
end

def color_number(game)
  number = game.split(' ')[0].to_i
  color = game.split(' ')[1]
  [number, color]
end

Benchmark.bm do |x|
  x.report do
    lines = ARGF.read.lines
    part_one(lines)
    part_two(lines)
  end
end
