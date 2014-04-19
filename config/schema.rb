ActiveRecord::Schema.define(version: 0) do
  create_table :jobs, force: true do |t|
    t.integer :job_type, null: false
    t.text :arguments
    t.boolean :in_running, default: false
    t.integer :priority, default: 100
    t.datetime :scheduled_on
    t.datetime :updated_at
    t.datetime :created_at
  end
end
