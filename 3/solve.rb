#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'

# symbol = all chars except digit or dot
SYMBOL = /[^0-9.]/.freeze

def part_one(lines)
  lines.each_with_index do |line, y|
    current_number = ''
    is_part = false
    gear_coords = []
    line.chars.each_with_index do |char, x|
      if numeric?(char)
        current_number += char
        neighbors = neighbors(x, y)
        is_part ||= part?(neighbors)
        gear_coords << find_gear_coords(neighbors)
        if x == line.length - 1 # end of line
          handle_part(current_number, is_part)
          handle_gear(current_number, gear_coords, is_part)
        end
        next
      end

      next unless current_number != '' # end of number

      handle_part(current_number, is_part)
      handle_gear(current_number, gear_coords, is_part)
      is_part = false
      current_number = ''
      gear_coords = []
    end
  end
end

def find_gear_coords(neighbors)
  neighbors.values.map do |neighbor|
    next if neighbor[:char].nil?
    next unless neighbor[:char] == '*'

    { x: neighbor[:x], y: neighbor[:y] }
  end.compact
end

def part?(neighbors)
  neighbors.values.map { _1[:char] }.reject(&:nil?).any? { |char| char.match?(SYMBOL) }
end

def neighbors(coord_x, coord_y)
  x = coord_x
  y = coord_y
  top_left = @lines[y - 1][x - 1] if y.positive? && x.positive?
  top = @lines[y - 1][x] if y.positive?
  top_right = @lines[y - 1][x + 1] if y.positive? && x < @line_length
  left = @lines[y][x - 1] if x.positive?
  right = @lines[y][x + 1] if x < @line_length
  bottom_left = @lines[y + 1][x - 1] if y < @nb_lines && x.positive?
  bottom = @lines[y + 1][x] if y < @nb_lines
  bottom_right = @lines[y + 1][x + 1] if y < @nb_lines && x < @line_length

  {
    top_left: {
      x: x - 1,
      y: y - 1,
      char: top_left
    },
    top: {
      x: x,
      y: y - 1,
      char: top
    },
    top_right: {
      x: x + 1,
      y: y - 1,
      char: top_right
    },
    left: {
      x: x - 1,
      y: y,
      char: left
    },
    right: {
      x: x + 1,
      y: y,
      char: right
    },
    bottom_left: {
      x: x - 1,
      y: y + 1,
      char: bottom_left
    },
    bottom: {
      x: x,
      y: y + 1,
      char: bottom
    },
    bottom_right: {
      x: x + 1,
      y: y + 1,
      char: bottom_right
    }
  }
end

def handle_part(number, is_part)
  if is_part
    @parts << number
  else
    @not_parts << number
  end
end

def handle_gear(current_number, gear_coords, is_part)
  gear_coords.flatten!.uniq!
  return unless is_part && gear_coords.any?

  gear_coords.each do |gear_coord|
    @gears[gear_coord] = @gears[gear_coord] ? @gears[gear_coord] << current_number : [current_number]
  end
end

def numeric?(char)
  char.match?(/[0-9]/)
end

def part_two
  acc = 0
  @gears.each_value do |numbers|
    next if numbers.length < 2

    acc += numbers.map(&:to_i).reduce(:*)
  end
  acc
end

Benchmark.bm do |x|
  x.report do
    lines = ARGF.read.lines
    @parts = []
    @not_parts = []
    @gears = {}

    @nb_lines = lines.length - 1
    @line_length = lines[0].length - 1
    @lines = lines.map(&:chomp)

    part_one(@lines)
    puts "parts_sum: #{@parts.map(&:to_i).sum}"
    # puts "not_parts: #{@not_parts}, sum: #{@not_parts.map(&:to_i).sum}"
    # puts "gears: #{@gears}"

    puts "gears_ratio: #{part_two}"
  end
end
