require File.dirname(__FILE__) + '/spec_helper'
require 'french_time_dimension_builder'

describe FrenchTimeDimensionBuilder do

  def times(from,to,key=nil)
    result = FrenchTimeDimensionBuilder.new(from,to).build
    result.map! { |e| e[key] } unless key.nil?
    result
  end
  
  def time(time,key=nil)
    times(time,time,key).first
  end
  
  it "should return exactly one record for each minute of the 24 hours day" do
    times('0:00','23:59',:sql_time_stamp).size.should eql(60*24)
  end
  
  it "should fill the sql_time_stamp" do
    time('21:00',:sql_time_stamp).should eql('21:00')
  end
  
  it "should fill the hour as integer" do
    times('21:00','21:59',:heure).uniq.should eql([21])
  end
  
  it "should fill the hour description in french" do
    times('7:00','7:59',:heure_descriptive).uniq.should eql(["entre 07h00 et 08h00"])
  end
  
  it "should fill the half hour description french" do
    times('20:00','20:29',:demi_heure_descriptive).uniq.should eql(["entre 20h00 et 20h30"])
    times('20:30','20:59',:demi_heure_descriptive).uniq.should eql(["entre 20h30 et 21h00"])
    times('7:00','7:29',:demi_heure_descriptive).uniq.should eql(["entre 07h00 et 07h30"])
  end
  
  it "should fill the period of the day in french" do
    times('0:00','7:59',:periode_de_la_journee).uniq.should eql(["nuit"])
    times('8:00','11:59',:periode_de_la_journee).uniq.should eql(["matinée"])
    times('12:00','18:59',:periode_de_la_journee).uniq.should eql(["après-midi"])
    times('19:00','21:59',:periode_de_la_journee).uniq.should eql(["soirée"])
    times('22:00','23:59',:periode_de_la_journee).uniq.should eql(["nuit"])
  end

  it "should states weither the hour is a closed or opened hour" do
    times('0:00','7:59',:type_d_horaires).uniq.should eql(["horaires fermeture"])
    times('8:00','18:59',:type_d_horaires).uniq.should eql(["horaires ouverture"])
    times('19:00','23:59',:type_d_horaires).uniq.should eql(["horaires fermeture"])
  end
  
end