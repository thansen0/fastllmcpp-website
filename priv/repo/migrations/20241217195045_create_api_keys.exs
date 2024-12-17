defmodule Fastllmcpp.Repo.Migrations.CreateApiKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :key, :uuid
      add :email, :string
      add :last_viewed, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
