defmodule FastllmcppWeb.PromptLive.FormComponent do
  use FastllmcppWeb, :live_component

  alias Fastllmcpp.Prompts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage prompt records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="prompt-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:prompt]} type="text" label="Prompt" />
        <.input field={@form[:response]} type="text" label="Response" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Prompt</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{prompt: prompt} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Prompts.change_prompt(prompt))
     end)}
  end

  @impl true
  def handle_event("validate", %{"prompt" => prompt_params}, socket) do
    changeset = Prompts.change_prompt(socket.assigns.prompt, prompt_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"prompt" => prompt_params}, socket) do
    save_prompt(socket, socket.assigns.action, prompt_params)
  end

  defp save_prompt(socket, :edit, prompt_params) do
    case Prompts.update_prompt(socket.assigns.prompt, prompt_params) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})

        {:noreply,
         socket
         |> put_flash(:info, "Prompt updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_prompt(socket, :new, prompt_params) do
    case Prompts.create_prompt(prompt_params) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})

        {:noreply,
         socket
         |> put_flash(:info, "Prompt created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
