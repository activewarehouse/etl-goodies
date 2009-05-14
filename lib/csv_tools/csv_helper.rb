require 'fastercsv'

module CsvHelper
  # return the fields names as symbols by reading the first line of the file
  # if a given fields appears twice or more, return it with its occurrence index (eg: name_1, then name_2...)
  def self.get_fields_names(file)
    File.open(file) do |input|
      fields = FasterCSV.parse(input.readline).first
      new_fields = []
      fields.each_with_index do |field,index|
        # compute the index of occurrence of this specific occurrence of the field (usually, will be 1)
        occurrence_index = fields[0..index].find_all { |e| e == field }.size
        number_of_occurrences = fields.find_all { |e| e == field }.size
        new_field = field + (number_of_occurrences > 1 ? "_#{occurrence_index}" : "")
        new_fields << new_field
      end
      return new_fields.map(&:to_sym)
    end
  end
  
  # return all the values of a given field in the file - useful for small lookups
  def self.get_field_values(file,field_name)
    values = []
    FasterCSV.foreach(file,:col_sep => ';',:headers => true) do |row|
      values << row[field_name]
    end
    values
  end
end
