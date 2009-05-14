module ETL
  module Processor
    # Ensure that each specified field is available
    class EnsureFieldsPresenceProcessor < ETL::Processor::RowProcessor
      def process(row)
        missing_fields = configuration[:fields] - row.keys
        throw "ERROR : #{self.class} : missing required field(s) #{missing_fields.join(',')} in row. Available fields are : #{row.keys.join(',')}" unless missing_fields.empty?
        row
      end
    end
  end
end
