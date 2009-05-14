require File.dirname(__FILE__) + '/spec_helper'
require 'fixed_width_file_destination'

describe ETL::Control::FixedWidthFileDestination do

  attr_reader :destination
  TARGET = 'temp-fixed-width-file-destination.txt'

  before(:each) do
    control = mock("control", :file => File.dirname(__FILE__) + '/fake-control.ctl')
    configuration = { :file => TARGET, :format => [[:age, 2],[:sex,1]], :eol => "\r\n" }
    @destination = ETL::Control::FixedWidthFileDestination.new(control,configuration)
  end
  
  def output
    # careful - one might think that IO.readlines(xxx) would read as binary
    # it does, unless you're on windows
    # http://blog.leosoto.com/2008/03/reading-binary-file-on-ruby.html
    File.open(destination.file, "rb") { |io| io.read }
  end
    
  it "outputs all the fields and terminate by eol" do
    # note - on windows, opening a file with "w" instead of "wb" would not output what's expected (\r\r\n instead of \r\n)
    # this test is here to ensure the behaviour does not change in the future
    destination.write( { :age => "27", :sex => "M"} )
    destination.write( { :age => "20", :sex => "F"} )
    destination.close
    
    output.should == "27M\r\n20F\r\n"
  end
  
  it "raises an error when a data is larger than corresponding field" do
    lambda do
      destination.write( { :age => 270, :sex => "M" })
      destination.close 
    end.should raise_error("field age is too large (max width 2)")
  end
  
  it "converts int to string" do
    destination.write( { :age => 27, :sex => "M" })
    destination.close
    output.should == "27M\r\n"
  end

end