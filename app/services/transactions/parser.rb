module Transactions
	class Parser
		attr_reader :file

		def initialize(file:)
			@file = file
		end

		def call
			file.each_line.lazy.map do |line|
				init_transaction_from(line)
			end
		end

		private

		def init_transaction_from(line)
			ts, uuid, user_id, amount = line.chomp.strip.split(',')
			Transaction.new(
				uuid: uuid,
				timestamp: DateTime.parse(ts),
				user_id: user_id,
				amount: amount.to_f
			)
		end
	end
end