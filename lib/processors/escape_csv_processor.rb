require 'fileutils'

module ETL #:nodoc:
  module Processor #:nodoc:
    class EscapeCsvProcessor < ETL::Processor::Processor
      
      # The file to load from
      attr_reader :source_file
      # The file to write to
      attr_reader :target_file
      # whether to use a temporary file or not
      attr_reader :use_temp_file
      
      # Initialize the processor.
      #
      # Configuration options:
      # * <tt>:source_file</tt>: The file to load data from
      # * <tt>:target_file</tt>: The file to write data to
      # * <tt>:file</tt>: short-cut which will set the same value to both source_file and target_file
      def initialize(control, configuration)
        super
        if configuration[:file]
          @use_temp_file = true
          configuration[:source_file] = configuration[:file]
          configuration[:target_file] = configuration[:file] + '.tmp'
        end
        @source_file = File.join(File.dirname(control.file), configuration[:source_file])
        @target_file = File.join(File.dirname(control.file), configuration[:target_file])
        raise ControlError, "Source file must be specified" if @source_file.nil?
        raise ControlError, "Target file must be specified" if @target_file.nil?
        raise ControlError, "Source and target file cannot currently point to the same file" if source_file == target_file
      end
      
      # Execute the processor
      def process
        File.open(source_file) do |source|
          File.open(target_file,'w') do |target|
            source.each_line do |line|
              target << line.gsub('\"','""')
            end
          end
        end
        if use_temp_file
          FileUtils.rm(source_file)
          FileUtils.mv(target_file,source_file)
        end
      end
    end
  end
end