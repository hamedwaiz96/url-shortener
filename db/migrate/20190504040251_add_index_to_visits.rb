class AddIndexToVisits < ActiveRecord::Migration[5.2]
  def change
    add_index :visits, :url_id
    add_index :visits, :submitter_id
  end
end
