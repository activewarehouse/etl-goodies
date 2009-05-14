require File.dirname(__FILE__) + '/spec_helper'
require 'french_date_dimension_builder'

describe FrenchDateDimensionBuilder do

  def days(from,to,key=nil)
    result = FrenchDateDimensionBuilder.new(from,to).build
    result.map! { |e| e[key] } unless key.nil?
    result
  end
  
  def day(from,key=nil)
    days(from,from,key).first
  end
  
  it "should return the expected number of days" do
    days('2007-01-01','2007-12-31').size.should eql(365) 
  end
  
  it "should return :date formatted for french culture" do
    day('2007-12-31',:date).should eql('31/12/2007')
  end
  
  it "should return :date_descriptive for french culture" do
    day('2007-12-31',:date_descriptive).should eql('lundi 31 décembre 2007')
  end

  it "should return :date_descriptive for french culture with 1er for first day of the month" do
    day('2008-01-01',:date_descriptive).should eql('mardi 1er janvier 2008')
  end
  
  it "should return :mois in french" do
    (1..12).map { |month| day("2007-#{month}-01",:mois) }.should eql(
      %w(janvier février mars avril mai juin juillet août septembre octobre novembre décembre)
    )
  end
  
  it "should return :annee on four digits" do
    days('1959-1-1','1959-12-31',:annee).uniq.should eql(%w(1959))
  end
  
  it "should return :annee_et_mois in a sortable fashion" do
    day('2008-02-03',:annee_et_mois).should eql('2008-02')
    day('2008-12-03',:annee_et_mois).should eql('2008-12')
  end
  
  it "should return all the days of week in french" do
    days('2007-12-01','2007-12-07',:jour_de_la_semaine).should eql(%w(samedi dimanche lundi mardi mercredi jeudi vendredi))
  end
  
  it "should return a sql_date_stamp" do
    day('1991-1-1',:sql_date_stamp).should eql(Date.parse("1991-1-1"))
  end
  
  it "should return :trimestre in french" do
    day('2007-12-01',:trimestre).should eql('T4')
    day('2007-06-30',:trimestre).should eql('T2')
  end

  it "should implement quarter properly - it's home baked after all" do
    (1..12).map { |month| day("2007-#{month}-01",:trimestre) }.should eql(%w(T1 T1 T1 T2 T2 T2 T3 T3 T3 T4 T4 T4))
  end
  
  it "should return :semestre in french" do
    day('2007-7-1',:semestre).should eql('S2')
    day('2007-06-30',:semestre).should eql('S1')
    day('2007-12-31',:semestre).should eql('S2')
  end
  
  it "should return :semaine in french" do
    # http://fr.wikipedia.org/wiki/ISO_8601
    day('2008-1-1',:semaine).should eql('semaine 1')
  end

  it "should return :semaine in french, and respect ISO 8601" do
    # http://fr.wikipedia.org/wiki/ISO_8601
    day('2009-12-31',:semaine).should eql('semaine 53')
    day('2010-1-1',:semaine).should eql('semaine 53')
    day('2010-1-4',:semaine).should eql('semaine 1')
  end
  
end