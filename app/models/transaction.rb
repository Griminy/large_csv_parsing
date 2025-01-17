class Transaction
	attr_accessor :uuid, :user_id, :amount, :timestamp

	def initialize(uuid:, user_id:, amount:, timestamp:)
		@uuid = uuid
		@user_id = user_id
		@amount = amount
		@timestamp = timestamp
	end

	def to_row
		[timestamp.iso8601, uuid, user_id, amount.to_f].join(',')
	end
end