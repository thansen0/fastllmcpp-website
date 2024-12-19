defmodule Fastllmcpp.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :prompt, :text
      add :response, :text
      add :api_key_key, references(:api_keys, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:prompts, [:api_key_key])
  end
end
