require File.dirname(__FILE__) + '/spec_helper'
require 'csv_helper'

describe CsvHelper do

  before(:each) do
    @input = mock("fake input")
    File.should_receive(:open).with('file.txt').and_yield(@input)
  end
  
  def set_input(content)
    @input.should_receive(:readline).and_return(content)
  end
  
  def output
    CsvHelper.get_fields_names("file.txt")
  end

  it "should return the first line of the given file as symbols" do
    set_input "first_name,last_name,age"
    output.should eql([:first_name,:last_name,:age])
  end
  
  it "should handle spaces and accents in characters" do
    set_input "prénom,nom de famille"
    output.should eql([:"prénom",:"nom de famille"])
  end
  
  it "should append the field occurence number when working with duplicates" do
    set_input "some_data,some_data,name,name,other,name"
    output.should eql([:some_data_1,:some_data_2,:name_1,:name_2,:other,:name_3])
  end

end