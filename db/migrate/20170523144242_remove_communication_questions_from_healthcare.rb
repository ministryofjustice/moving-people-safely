class RemoveCommunicationQuestionsFromHealthcare < ActiveRecord::Migration[5.0]
  def change
    remove_column :healthcare, :hearing_speech_sight_issues, :string
    remove_column :healthcare, :hearing_speech_sight_issues_details, :text
    remove_column :healthcare, :reading_writing_issues, :string
    remove_column :healthcare, :reading_writing_issues_details, :text
  end
end
