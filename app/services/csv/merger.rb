module Csv
	class Merger
		def initialize(out_path:, chunk_files:)
			@out_path = out_path
			@chunk_files = chunk_files
		end

		def call
			File.open(@out_path, 'w') do |output|
				sorted_chunks = @chunk_files.map do |tempfile|
					parse_transactions(tempfile)
				end
				
				sort_chunks!(sorted_chunks)

				while sorted_chunks.any?
					max_enum = sorted_chunks.first
					output.puts(max_enum.next.to_row)

					begin
						max_enum.peek
						sort_chunks!(sorted_chunks)
					rescue StopIteration
						sorted_chunks.shift
					end
				end
			end
		end

		private

		def sort_chunks!(enums)
			1.upto(enums.length - 1) do |i|
				current_enum = enums[i]
				prev_index = i - 1

				while prev_index >= 0 && enums[prev_index].peek.amount < current_enum.peek.amount
					enums[prev_index + 1] = enums[prev_index]
					prev_index -= 1
				end

				enums[prev_index + 1] = current_enum
			end
		end

		def parse_transactions(tempfile)
			Transactions::Parser.new(file: tempfile).call
		end
	end
end