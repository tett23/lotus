ActiveRecord::Schema.define(version: 0) do
  create_table :jobs do |t|
    t.integer :type, null: false
    t.datetime :updated_at
    t.datetime :created_at
  end
end
