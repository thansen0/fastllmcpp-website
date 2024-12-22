defmodule FastllmcppWeb.ApiKeyLive.Show do
  use FastllmcppWeb, :live_view

  alias Fastllmcpp.ApiKeys
  alias Fastllmcpp.Prompts

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, stream(socket, :prompts, Prompts.list_prompts())}
    if connected?(socket) do
      Prompts.subscribe()
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    api_key = ApiKeys.get_api_key!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:api_key, api_key)
     |> stream(:prompts, Prompts.list_prompts_for_api_key(api_key.key))}
  end

  @impl true
  def handle_info({FastllmcppWeb.ApiKeyLive.FormComponent, {:saved, prompt}}, socket) do
    {:noreply, stream_insert(socket, :prompts, prompt)}
    # if prompt.api_key_key == socket.assigns.api_key.key do
    #   {:noreply, stream_insert(socket, :prompts, prompt)}
    # else
    #   {:noreply, socket}
    # end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    prompt = Prompts.get_prompt!(id)
    {:ok, _} = Prompts.delete_prompt(prompt)

    {:noreply, stream_delete(socket, :prompts, prompt)}
  end

  defp page_title(:show), do: "Show ApiKey"
  defp page_title(:edit), do: "Edit ApiKey"
end
