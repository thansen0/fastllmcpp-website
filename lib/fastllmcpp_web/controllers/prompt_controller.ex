defmodule FastllmcppWeb.PromptController do
  use FastllmcppWeb, :controller
#   use FastllmcppWeb, :live_view

  alias Fastllmcpp.Prompts
  alias Fastllmcpp.Prompts.Prompt

  # POST /api/prompts
  def create(conn, %{"prompt" => prompt_params}) do
    case Prompts.create_prompt(prompt_params) do
      {:ok, %Prompt{} = prompt} ->
        conn
        |> put_status(:created)
        # |> render("show.json", prompt: prompt)
        |> render(:show, prompt: prompt)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  # GET /api/prompts/:id
  def show(conn, %{"id" => id}) do
    prompt = Prompts.get_prompt!(id)
    render(conn, "show.json", prompt: prompt)
  end
end
