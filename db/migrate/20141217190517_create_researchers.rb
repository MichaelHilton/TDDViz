class CreateResearchers < ActiveRecord::Migration
  def change

    create_table :researchers do |t|
      t.string :name

      t.timestamps
    end

    create_table :markup_assignments do |t|
      t.references :researcher, index: true
      t.references :session, index: true

      t.timestamps
    end

    create_table :interrater_sessions do |t|
      t.references :session, index: true

      t.timestamps
    end
  end
end
