Dir[File.dirname(__FILE__) + "/../lib/*"].each { |folder| $LOAD_PATH << folder }

require 'rubygems'
require 'fastercsv'
require 'etl' # sudo gem install activewarehouse-etl
