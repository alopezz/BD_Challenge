defmodule ContactInfo.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :case_id, :string
      add :title, :string
      add :first_name, :string
      add :last_name, :string
      add :mobile_phone_number, :string
      add :address, :string

      timestamps()
    end

    create unique_index(:contacts, [:case_id])
  end
end
