class AddCommunicationColumnsToHealhcare < ActiveRecord::Migration[5.0]
  def change
    add_column :healthcare, :hearing_speech_sight_issues, :string
    add_column :healthcare, :hearing_speech_sight_issues_details, :text
    add_column :healthcare, :reading_writing_issues, :string
    add_column :healthcare, :reading_writing_issues_details, :text
  end
end
