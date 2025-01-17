module Transactions
	class Writter
		attr_reader :collection, :out_file

		def initialize(collection:, out_file:)
			@collection = collection
			@out_file = out_file
		end

		def call
			collection.each do |transaction|
				out_file.puts(transaction.to_row)
			end
		end
	end
end