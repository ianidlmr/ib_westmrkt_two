class ChangeCountryCodeToCountry < ActiveRecord::Migration[5.0]
  def up
    rename_column :addresses, :country_code, :country
  end

  def down
    rename_column :addresses, :country, :country_code
  end
end
