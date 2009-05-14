module ETL #:nodoc:
  module Control #:nodoc:
    # File as the final destination.
    class FixedWidthFileDestination < Destination
      # The File to write to
      attr_reader :file
      
      # The format array: [["first_field_name",width_in_chars],[...]]
      attr_reader :format
      
      # The end of line marker
      attr_accessor :eol
      
      # Initialize the object.
      # * <tt>control</tt>: The Control object
      # * <tt>configuration</tt>: The configuration map
      # * <tt>mapping</tt>: The output mapping
      # 
      # Configuration options:
      # * <tt>:file</tt>: The file to write to (REQUIRED)
      # * <tt>:format</tt>: The format array
      # * <tt>:eol</tt>: End of line marker (default is \n)
      def initialize(control, configuration, mapping={})
        super
        @file = File.join(File.dirname(control.file), configuration[:file])
        @format = configuration[:format]
        raise ControlError, "Format required in mapping" unless @format
        @eol = configuration[:eol] || "\n"
      end
      
      # Close the destination. This will flush the buffer and close the underlying stream or connection.
      def close
        buffer << append_rows if append_rows
        flush
        f.close
      end
      
      # Flush the destination buffer
      def flush
        buffer.flatten.each do |row|
          format.each do |field,width|
            value = row[field].to_s
            raise "field #{field} is too large (max width #{width})" if value.size > width
            f.write(value.ljust(width))
          end
          f.write(eol)
        end
        f.flush
        buffer.clear
      end
      
      private
      # Get the open file stream
      def f
        @f ||= open(file, "wb")
      end
    end
  end
end