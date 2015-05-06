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

ActiveRecord::Schema.define(version: 1) do
  create_table :programs do |t|
    t.integer :count
    t.string :title
    t.string :episode_name
    t.string :channel_name
    t.integer :channel_id
    t.datetime :start_at
    t.datetime :end_at
    t.datetime :last_updated_at
  end
end
