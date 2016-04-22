module MeshChat
  module Database
    module_function

    # Upon initial startup, instantiated the database
    # this is used for storing the information of every node
    # on the network
    def setup_storage
      ActiveRecord::Base.establish_connection(
          adapter: "sqlite3",
          database: "meshchat.sqlite3",
          pool: 128
      )

      ActiveRecord::Migration.suppress_messages do
        ActiveRecord::Schema.define do
          unless data_source_exists? :entries
            create_table :entries do |table|

              table.column :alias_name, :string
              table.column :uid, :string
              table.column :public_key, :string

              table.column :location_on_network, :string
              table.column :location_of_relay, :string

              table.column :on_local_network, :boolean, default: true, null: false
              table.column :on_relay, :boolean, default: false, null: false
            end
          end
        end
      end
    end
  end
end
