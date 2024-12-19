defmodule Fastllmcpp.Prompts.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "prompts" do
    field :response, :string
    field :prompt, :string

    # issue: it's checking the api_key_id, not api_key_key. Very frustrating
    # belongs_to :api_key, Fastllmcpp.ApiKeys.ApiKey, foreign_key: :api_key_id
    belongs_to :api_key, Fastllmcpp.ApiKeys.ApiKey,
      foreign_key: :api_key_key,
      references: :key,
      type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:prompt, :response, :api_key_key])
    |> put_default_api_key_key()
    |> validate_required([:prompt, :response])
  end

  defp put_default_api_key_key(changeset) do
    case get_field(changeset, :api_key_key) do
      nil -> put_change(changeset, :api_key_key, "41b7e237-2406-4649-9768-5de24faf83d4")
      _ -> changeset
    end
  end
end
