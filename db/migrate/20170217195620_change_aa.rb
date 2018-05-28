class ChangeAa < ActiveRecord::Migration[5.0]
  def change
    rename_column :contacts, :aa_application_submitted, :va_application_submitted
  end
end
