module ETL #:nodoc:
  module Transform #:nodoc:
    # Achieve a look-up like the DecodeTransform, but return the value unchanged instead of the default value if no match is found.
    class CleanUpTransform < DecodeTransform
      def transform(name, value, row)
        decode_table[value] || value
      end
    end
  end
end
