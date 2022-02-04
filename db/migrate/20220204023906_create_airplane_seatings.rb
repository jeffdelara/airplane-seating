class CreateAirplaneSeatings < ActiveRecord::Migration[6.1]
  def change
    create_table :airplane_seatings do |t|
      t.string :seat

      t.timestamps
    end
  end
end
