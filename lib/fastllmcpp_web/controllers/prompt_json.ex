defmodule FastllmcppWeb.PromptJSON do
  def show(%{prompt: prompt}) do
    %{data: %{id: prompt.id, prompt: prompt.prompt, response: prompt.response}}
  end

  def error(%{changeset: changeset}) do
    %{errors: translate_changeset_errors(changeset)}
  end

  defp translate_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
      # You can do custom translation here if you like
      Phoenix.Naming.humanize(msg)
    end)
  end
end
