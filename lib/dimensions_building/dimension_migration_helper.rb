module DimensionMigrationHelper
  def self.create_table_from_fields(migrator,table_name,fields)
    migrator.create_table table_name do |t|
      fields.each do |name,type|
        t.column name, type, :null => false
      end
    end
    fields.each do |name,type|
      migrator.add_index table_name, name unless type == :text      
    end
  end
end