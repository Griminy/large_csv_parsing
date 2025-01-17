module Transactions
  class Sorter
    BUCKET_SIZE = 100

    attr_reader :collection

    def initialize(collection:)
      @collection = collection
    end

    def call
      return collection.dup if collection.nil? || collection.size <= 1

      min_amount, max_amount = find_min_max

      bucket_count = ((max_amount - min_amount) / BUCKET_SIZE).ceil + 1
      buckets = Array.new(bucket_count) { [] }

      collection.each do |transaction|
        bucket_index = ((transaction.amount - min_amount) / BUCKET_SIZE).floor
        buckets[bucket_index] << transaction
      end

      result = []
      buckets.reject(&:empty?).reverse_each do |bucket|
        sorted_bucket = merge_sort(bucket)
        result.concat(sorted_bucket)
      end

      result.lazy
    end

    private

    def find_min_max
      return [0, 0] if collection.empty?

      min = max = collection.first.amount
      collection.each do |transaction|
        amount = transaction.amount
        min = amount if amount < min
        max = amount if amount > max
      end
      [min, max]
    end

    def merge_sort(array)
      return array if array.size <= 1

      mid = array.size / 2
      left = merge_sort(array[0...mid])
      right = merge_sort(array[mid..-1])

      merge_parts(left, right)
    end

    def merge_parts(left, right)
      [].tap do |result|
        until left.empty? || right.empty?
          if left.first.amount > right.first.amount
            result << left.shift
          else
            result << right.shift
          end
        end
      end.concat(left).concat(right)
    end
  end
end