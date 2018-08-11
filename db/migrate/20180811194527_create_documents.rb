class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :name, null: false, index: {unique: true}
      t.text :description

      t.timestamps
    end
  end
end
