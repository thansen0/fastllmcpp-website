defmodule FastllmcppWeb.ApiKeyLive.FormComponent do
  use FastllmcppWeb, :live_component

  alias Fastllmcpp.ApiKeys

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage api_key records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="api_key-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:email]} type="text" label="Email (optional)" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Api key</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
          # <.input field={@form[:key]} type="text" label="Key" />

  @impl true
  def update(%{api_key: api_key} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ApiKeys.change_api_key(api_key))
     end)}
  end

  @impl true
  def handle_event("validate", %{"api_key" => api_key_params}, socket) do
    changeset = ApiKeys.change_api_key(socket.assigns.api_key, api_key_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"api_key" => api_key_params}, socket) do
    save_api_key(socket, socket.assigns.action, api_key_params)
  end

  defp save_api_key(socket, :edit, api_key_params) do
    case ApiKeys.update_api_key(socket.assigns.api_key, api_key_params) do
      {:ok, api_key} ->
        notify_parent({:saved, api_key})

        {:noreply,
         socket
         |> put_flash(:info, "Api key updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_api_key(socket, :new, api_key_params) do
    # api_key_params = Map.merge(api_key_params, %{
    #   "uuid" => Ecto.UUID.generate()
    # })
    # api_key_params = 
    #   api_key_params
    #   |> Map.put("uuid", Ecto.UUID.generate())

    case ApiKeys.create_api_key(api_key_params) do
      {:ok, api_key} ->
        notify_parent({:saved, api_key})

        {:noreply,
         socket
         |> put_flash(:info, "Api key created successfully")
         |> push_navigate(to: ~p"/api_keys/#{api_key.id}")}
        #  |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
