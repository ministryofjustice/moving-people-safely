class RemoveDeviseRelatedFieldsFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, name: "index_users_on_invitation_token"
    remove_index :users, name: "index_users_on_invitations_count"
    remove_index :users, name: "index_users_on_invited_by_id"
    remove_index :users, name: "index_users_on_reset_password_token"

    remove_columns(
      :users,
      :encrypted_password,
      :reset_password_token,
      :reset_password_sent_at,
      :remember_created_at,
      :sign_in_count,
      :current_sign_in_at,
      :last_sign_in_at,
      :current_sign_in_ip,
      :last_sign_in_ip,
      :invitation_token,
      :invitation_created_at,
      :invitation_sent_at,
      :invitation_accepted_at,
      :invitation_limit,
      :invited_by_type,
      :invited_by_id,
      :invitations_count
    )
  end
end
