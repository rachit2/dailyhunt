class CreateApplicationMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :application_messages do |t|
      t.string :name

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        BxBlockLanguageoptions::ApplicationMessage.create_translation_table!({:message => {:type => :text, :null => false}}, {
          :migrate_data => true
        })
      end

      dir.down do
        BxBlockLanguageoptions::ApplicationMessage.drop_translation_table!
      end
    end

  end
end
