#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'
require 'byebug'

def ticket(line)
  card_number = line.split(': ').first.split(' ').last.to_i
  winning_numbers, ticket_numbers = line.split(': ').last.split(' | ').map do |numbers|
    numbers.split.map(&:to_i)
  end
  { card_number: card_number, winning_numbers: winning_numbers, ticket_numbers: ticket_numbers }
end

def count_points(my_ticket)
  points = 0
  my_ticket[:winning_numbers].each do |winning_number|
    my_ticket[:ticket_numbers].each do |ticket_number|
      if winning_number == ticket_number
        if points.zero?
          points = 1
        else
          points *= 2
        end
      end
    end
  end
  points
end

def part_one(lines)
  total_points = 0
  lines.each do |line|
    my_ticket = ticket(line)
    total_points += count_points(my_ticket)
    # puts "Card #{my_ticket[:card_number]}: #{points}"
  end
  puts "Total points: #{total_points}"
end

Benchmark.bm do |x|
  x.report do
    lines = ARGF.read.lines.map(&:chomp)

    part_one(lines)
  end
end
