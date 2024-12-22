defmodule Fastllmcpp.ApiKeys.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "api_keys" do
    # field :id, :binary_id, primary_key: true, autogenerate: true
    field :key,:binary_id
    field :email, :string, default: ""
    field :last_viewed, :utc_datetime
    has_many :prompts, Fastllmcpp.Prompts.Prompt,
      foreign_key: :api_key_key,
      references: :key

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:email, :last_viewed, :key])
    |> put_key()
    |> put_change(:last_viewed, DateTime.truncate(DateTime.utc_now(), :second))
    |> validate_required([:key, :last_viewed])
    |> unique_constraint(:key)
  end

  defp put_key(changeset) do
    case get_field(changeset, :key) do
      nil -> put_change(changeset, :key, Ecto.UUID.generate())
      _ -> changeset
    end
  end
end
