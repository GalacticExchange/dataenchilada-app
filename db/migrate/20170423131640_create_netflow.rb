class CreateNetflow < ActiveRecord::Migration
  def change
    create_table :in_netflow_details do |t|
      t.integer :source_id

      t.string :bind
      t.integer :port
      t.string :switched_times_from_uptime
      t.string :tag


      t.timestamp
    end
  end
end
