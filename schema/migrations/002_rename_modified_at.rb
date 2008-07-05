migration(2, :rename_modified_at) do
  up do
    modify_table :adviser_relationships do
      rename_column :modified_at, :updated_at
    end
    modify_table :contact_relationships do
      rename_column :modified_at, :updated_at
    end
    modify_table :group_relationships do
      rename_column :modified_at, :updated_at
    end
  end

  down do
    modify_table :adviser_relationships do
      rename_column :updated_at, :modified_at
    end
    modify_table :contact_relationships do
      rename_column :updated_at, :modified_at
    end
    modify_table :group_relationships do
      rename_column :updated_at, :modified_at
    end
  end
end
