class Fluentd
  module Setting
    class InSqlTable < ActiveRecord::Base
      belongs_to :source

      KEYS = [:table, :update_column_val, :time_column, :primary_key]

      def fields_descriptions
        {
          # tag: 'tag name of events (optional; default value is table name)',
          table: '* RDBM table name',
          update_column_val: '* see above description',
          time_column: "(optional): if this option is set, this plugin uses this column's value as the the event's time. Otherwise it uses current time.",
          primary_key: "(optional): if you want to get data from the table which doesn't have primary key like PostgreSQL's View, set this parameter."
        }
      end
    end
  end
end
