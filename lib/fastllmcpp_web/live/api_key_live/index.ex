defmodule FastllmcppWeb.ApiKeyLive.Index do
  use FastllmcppWeb, :live_view

  alias Fastllmcpp.ApiKeys
  alias Fastllmcpp.ApiKeys.ApiKey

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, stream(socket, :api_keys, ApiKeys.list_api_keys())}
    form = to_form(%{"private_key" => nil}, as: :search)

    socket =
      socket
      |> assign(api_key: nil, error: nil) # Add form-related assigns
      |> assign(form: form)
      |> stream(:api_keys, ApiKeys.list_api_keys())

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Api key")
    |> assign(:api_key, ApiKeys.get_api_key!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Api key")
    |> assign(:api_key, %ApiKey{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Api keys")
    |> assign(:api_key, nil)
  end

  @impl true
  def handle_info({FastllmcppWeb.ApiKeyLive.FormComponent, {:saved, api_key}}, socket) do
    {:noreply, stream_insert(socket, :api_keys, api_key)}
  end

  @impl true
  # def handle_event("search", %{"private_key" => private_key}, socket) do
  def handle_event("search", %{"search" => %{"private_key" => private_key}}, socket) do
    case ApiKeys.get_api_id_by_key!(String.trim(private_key)) do
      nil ->
        {:noreply, assign(socket, error: "API Key not found")}

      api_key ->
        {:noreply, push_navigate(socket, to: ~p"/api_keys/#{api_key.id}")}
    end
  end
end
