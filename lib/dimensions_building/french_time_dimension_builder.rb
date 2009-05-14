require 'time'

class FrenchTimeDimensionBuilder
  # Specify the start time for the first record
  attr_accessor :start_time
  
  # Specify the end time for the last record
  attr_accessor :end_time

  # Avoid generating bad data on daylight change. If you are on a daylight changing day (ie: 2009/03/29) you'll get this:
  # >> Time.parse('1:59')+60               
  # => Sun Mar 29 03:00:00 0200 2009       => 3:00 is just after 1:59
  # Instead, append a day that hasn't got daylight change (2009/03/01)
  # >> Time.parse('2009/03/01 1:59')+60
  # => Sun Mar 01 02:00:00 0100 2009       => 2:00 is just after 1:59
  DAY_WITHOUT_DAYLIGHT_CHANGE = "2009/03/01 "
    
  # Initialize the builder.
  # 
  # * <tt>start_time</tt>: The start time.
  # * <tt>end_time</tt>: The end time.
  def initialize(start_time, end_time)
    @start_time = start_time.class == String ? Time.parse(DAY_WITHOUT_DAYLIGHT_CHANGE + start_time) : start_time
    @end_time = end_time.class == String ? Time.parse(DAY_WITHOUT_DAYLIGHT_CHANGE + end_time) : end_time
  end

  # Returns an array of hashes representing records in the dimension. The values for each record are 
  # accessed by name.
  def build(options={})
    records = []
    time = start_time
    while time <= end_time
      record = {}
      record[:sql_time_stamp] = time.strftime('%H:%M')
      record[:heure] = time.hour

      # full hour description
      full_hour_start = time.to_a
      full_hour_start[1] = 0 # set minutes to 0
      full_hour_start = Time.local(*full_hour_start)
      record[:heure_descriptive] = "entre #{full_hour_start.strftime('%Hh%M')} et #{(full_hour_start+60*60).strftime('%Hh%M')}"
      
      # half hour computation
      half_hour_start = time.to_a
      half_hour_start[1] = 30*(half_hour_start[1] / 30) # round to 0 or 30 minutes
      half_hour_start = Time.local(*half_hour_start)
      half_hour_end = half_hour_start + 30*60 # grab the next half by adding 30 minutes
      half_hour_start = half_hour_start.strftime('%Hh%M')
      half_hour_end = half_hour_end.strftime('%Hh%M')
      record[:demi_heure_descriptive] = "entre #{half_hour_start} et #{half_hour_end}"

      record[:type_d_horaires] = case time.hour
        when 8..18; "horaires ouverture"
        else "horaires fermeture"
      end
      
      record[:periode_de_la_journee] = case time.hour
        when 8..11; "matinée"
        when 12..18; "après-midi"
        when 19..21; "soirée"
        else "nuit"
      end
      
      records << record
      time = time + 60
    end
    records
  end

end
