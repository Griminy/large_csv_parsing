#!/usr/bin/env ruby

require 'tempfile'
require 'date'
require 'benchmark'
require 'parallel'

Dir["#{Dir.pwd}/app/**/*.rb"].each { |path| require_relative path }


FILE_PATH = ENV['FILE_PATH']
OUT_PATH = ENV.fetch('OUT_PATH', "#{Dir.pwd}/tmp/result_#{Time.now.to_i}.csv")
BATCH_SIZE = ENV.fetch('BATCH_SIZE', 10_000).to_i

raise 'FILE_PATH mast be set' if FILE_PATH.nil? || FILE_PATH.empty?


puts("Process is started\n")

chunk = []
chunk_files = []
benchmark_stats = Benchmark.measure do
	File.open(FILE_PATH, 'r') do |file|
		Transactions::Parser.new(file: file).call.each do |transaction|
			chunk << transaction
			if chunk.size >= BATCH_SIZE
				print('.')
				sorted_chunk = Transactions::Sorter.new(collection: chunk).call
				tempfile = Tempfile.new('chunk')
				Transactions::Writter.new(collection: sorted_chunk, out_file: tempfile).call
				tempfile.rewind
				chunk_files << tempfile
				chunk = []
			end
		end

		unless chunk.empty?
			print('.')
			sorted_chunk = Transactions::Sorter.new(collection: chunk).call
			tempfile = Tempfile.new('chunk')
			Transactions::Writter.new(collection: sorted_chunk, out_file: tempfile).call
			tempfile.rewind
			chunk_files << tempfile
		end
		print(".\n")

		Csv::Merger.new(out_path: OUT_PATH, chunk_files: chunk_files).call
	end

	chunk_files.each(&:close!)
end

puts("Stats: #{benchmark_stats}")
puts("Sorting result is here: #{OUT_PATH}")