defmodule FastllmcppWeb.PromptLive.Show do
  use FastllmcppWeb, :live_view

  alias Fastllmcpp.Prompts
  alias Fastllmcpp.ApiKeys

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    prompt = Prompts.get_prompt!(id)
    IO.puts(prompt.api_key_key)
    api_key = ApiKeys.get_api_id_by_key!(prompt.api_key_key) || ""

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:prompt, prompt)
     |> assign(:api_key, api_key)}
  end

  defp page_title(:show), do: "Show Prompt"
end
