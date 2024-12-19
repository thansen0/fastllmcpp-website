defmodule Fastllmcpp.PromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fastllmcpp.Prompts` context.
  """

  @doc """
  Generate a prompt.
  """
  def prompt_fixture(attrs \\ %{}) do
    {:ok, prompt} =
      attrs
      |> Enum.into(%{
        prompt: "some prompt",
        response: "some response"
      })
      |> Fastllmcpp.Prompts.create_prompt()

    prompt
  end
end
