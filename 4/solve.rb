#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'
require 'byebug'

def ticket(line)
  card_number = line.split(': ').first.split(' ').last.to_i
  winning_numbers, ticket_numbers = line.split(': ').last.split(' | ').map do |numbers|
    numbers.split.map(&:to_i)
  end
  t = { card_number: card_number, winning_numbers: winning_numbers, ticket_numbers: ticket_numbers }
  { **t, **count_points(t) }
end

def count_points(my_ticket)
  points = 0
  nb_matching_numbers = 0
  my_ticket[:winning_numbers].each do |winning_number|
    my_ticket[:ticket_numbers].each do |ticket_number|
      next unless winning_number == ticket_number

      nb_matching_numbers += 1
      if points.zero?
        points = 1
      else
        points *= 2
      end
    end
  end
  { nb_matching_numbers: nb_matching_numbers, points: points }
end

def part_one(lines)
  total_points = 0
  lines.each do |line|
    total_points += ticket(line)[:points]
  end
  puts "Total points: #{total_points}"
end

def part_two(lines)
  cards_counter = {}
  lines.each do |line|
    t = ticket(line)
    card_number = t[:card_number]
    nb_matching_numbers = t[:nb_matching_numbers]
    cards_counter[card_number] = cards_counter[card_number] ? cards_counter[card_number] + 1 : 1
    (1..cards_counter[card_number]).each do |_|
      (1..nb_matching_numbers).each do |i|
        cards_counter[card_number + i] = cards_counter[card_number + i] ? cards_counter[card_number + i] + 1 : 1
      end
    end
  end
  puts "total scratchcards: #{cards_counter.values.sum}"
end

Benchmark.bm do |x|
  x.report do
    lines = ARGF.read.lines.map(&:chomp)

    part_one(lines)
    part_two(lines)
  end
end
