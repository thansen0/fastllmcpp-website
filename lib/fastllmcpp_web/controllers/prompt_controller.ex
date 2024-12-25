defmodule FastllmcppWeb.PromptController do
  use FastllmcppWeb, :controller

  alias Fastllmcpp.Repo
  alias Fastllmcpp.ApiKeys.ApiKey

  alias Fastllmcpp.Prompts
  alias Fastllmcpp.Prompts.Prompt

  # GET /api/verify_pkey
  def verify(conn, %{"key" => key}) do
    case Repo.get_by(ApiKey, key: key) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid API key"})

      api_key ->
        conn
        |> put_status(:ok)
        |> json(%{key: api_key.key})
    end
  end

  def verify(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Missing API key"})
  end

  # POST /api/prompts
  def create(conn, %{"prompt" => prompt_params}) do
    case Prompts.create_prompt(prompt_params) do
      {:ok, %Prompt{} = prompt} ->
        conn
        |> put_status(:created)
        # |> render("show.json", prompt: prompt)
        |> render(:show, prompt: prompt)

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        # |> render(:error, changeset: changeset)
        |> json(%{error: "Unable to log prompt"})
    end
  end

  # GET /api/prompts/:id
  def show(conn, %{"id" => id}) do
    prompt = Prompts.get_prompt!(id)
    render(conn, "show.json", prompt: prompt)
  end
end
