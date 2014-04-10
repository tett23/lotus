ActiveRecord::Schema.define(version: 0) do
  create_table :jobs, force: true do |t|
    t.integer :type, null: false
    t.datetime :updated_at
    t.datetime :created_at
  end
end
