class AddMoreSettings < ActiveRecord::Migration[5.0]
  def change
    Setting.last_chance_limit = 5
    Setting.trending_limit = 300
  end
end
