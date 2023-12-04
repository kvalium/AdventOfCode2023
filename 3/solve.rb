#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'

# symbol = all chars except digit or dot
SYMBOL = /[^0-9.]/.freeze

def part_one(lines)
  parts = []
  not_parts = []

  lines.each_with_index do |line, y|
    current_number = ''
    is_part = false
    line.chars.each_with_index do |char, x|
      if numeric?(char)
        current_number += char
        is_part = true if adjacent_to_symbol?(lines, x: x, y: y) && !is_part
        if x == line.length - 1 # end of line
          if is_part
            parts << current_number
          else
            not_parts << current_number
          end
        end
        next
      elsif current_number != '' # end of number
        if is_part
          parts << current_number
        else
          not_parts << current_number
        end
        is_part = false
        current_number = ''
      end
    end
  end
  puts "parts: #{parts}, sum: #{parts.map(&:to_i).sum}"
  puts "not_parts: #{not_parts}, sum: #{not_parts.map(&:to_i).sum}"
end

def adjacent_to_symbol?(lines, x:, y:)
  nb_lines = lines.length - 1
  line_length = lines[y].length - 1
  top_left = lines[y - 1][x - 1] if y.positive? && x.positive?
  top = lines[y - 1][x] if y.positive?
  top_right = lines[y - 1][x + 1] if y.positive? && x < line_length
  left = lines[y][x - 1] if x.positive?
  right = lines[y][x + 1] if x < line_length
  bottom_left = lines[y + 1][x - 1] if y < nb_lines && x.positive?
  bottom = lines[y + 1][x] if y < nb_lines
  bottom_right = lines[y + 1][x + 1] if y < nb_lines && x < line_length

  [top_left, top, top_right, left, right, bottom_left, bottom, bottom_right].reject(&:nil?).any? do |char|
    char.match?(SYMBOL)
  end
end

def numeric?(char)
  char.match?(/[0-9]/)
end

Benchmark.bm do |x|
  x.report do
    lines = ARGF.read.lines
    part_one(lines)
  end
end
