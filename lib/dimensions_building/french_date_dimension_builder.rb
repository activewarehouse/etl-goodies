class FrenchDateDimensionBuilder
  # Specify the start date for the first record
  attr_accessor :start_date
  
  # Specify the end date for the last record
  attr_accessor :end_date
  
  # Initialize the builder.
  # 
  # * <tt>start_date</tt>: The start date.
  # * <tt>end_date</tt>: The end date.
  def initialize(start_date, end_date)
    @start_date = start_date.class == String ? Date.parse(start_date) : start_date
    @end_date = end_date.class == String ? Date.parse(end_date) : end_date
  end
  
  # Returns an array of hashes representing records in the dimension. The values for each record are 
  # accessed by name.
  def build(options={})
    records = []
    date = start_date
    while date <= end_date
      record = {}
      record[:date] = date.strftime("%d/%m/%Y")
      record[:mois] = %w(janvier février mars avril mai juin juillet août septembre octobre novembre décembre)[date.month-1]
      record[:jour_de_la_semaine] = %w(dimanche lundi mardi mercredi jeudi vendredi samedi)[date.wday]
      record[:annee] = date.year.to_s
      record[:annee_et_mois] = record[:annee] + "-" + date.month.to_s.rjust(2,'0')
      record[:date_descriptive] = "#{record[:jour_de_la_semaine]} #{date.day}#{date.day==1 ? 'er':''} #{record[:mois]} #{record[:annee]}"
      record[:sql_date_stamp] = date
      record[:semaine] = "semaine #{date.to_date.cweek}"
      # compute quarter ourselves - available in Time but not in Date - anything better ?
      quarter = 1 + (date.month-1) / 3
      record[:trimestre] = "T#{quarter}"
      record[:semestre] = "S#{(quarter+1)/2}"
      records << record
      date = date.next
    end
    records
  end
end
