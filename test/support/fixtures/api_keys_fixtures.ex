defmodule Fastllmcpp.ApiKeysFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fastllmcpp.ApiKeys` context.
  """

  @doc """
  Generate a api_key.
  """
  def api_key_fixture(attrs \\ %{}) do
    {:ok, api_key} =
      attrs
      |> Enum.into(%{
        email: "some email",
        key: "7488a646-e31f-11e4-aace-600308960662",
        last_viewed: ~U[2024-12-16 19:50:00Z]
      })
      |> Fastllmcpp.ApiKeys.create_api_key()

    api_key
  end
end
