# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  var        :string           not null
#  value      :text
#  thing_id   :integer
#  thing_type :string(30)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_settings_on_thing_type_and_thing_id_and_var  (thing_type,thing_id,var) UNIQUE
#

# RailsSettings Model
class Setting < RailsSettings::Base
  # set the value field, YAML encoded
  # KZ: Hack to ensure values are updated properly through RailsAdmin
  def value=(new_value)
    if !self.new_record? && value.class.eql?(Fixnum)
      self[:value] = new_value.to_i.to_yaml
    elsif !self.new_record? && value.class.eql?(Float)
      self[:value] = new_value.to_f.to_yaml
    else
      self[:value] = new_value.to_yaml
    end
  end

  rails_admin do
    list do
      field :var do
        label 'Setting'
      end
      field :value do
        pretty_value do       # used in list view columns and show views, defaults to formatted_value for non-association fields
          YAML.load(value)    # required to display the YAML value
        end
      end
    end

    show do
      field :var do
        label 'Setting'
      end
      field :value do
        pretty_value do       # used in list view columns and show views, defaults to formatted_value for non-association fields
          YAML.load(value)    # required to display the YAML value
        end
      end
    end

    edit do
      field :var do
        label 'Setting'
        read_only true
      end
      field :value do
        formatted_value do    # used in form views
          YAML.load(value)    # required to display the YAML value
        end
      end
    end
  end
end
