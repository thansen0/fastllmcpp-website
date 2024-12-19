defmodule FastllmcppWeb.Router do
  use FastllmcppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FastllmcppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FastllmcppWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/api_keys", ApiKeyLive.Index, :index
    live "/api_keys/new", ApiKeyLive.Index, :new
    live "/api_keys/:id/edit", ApiKeyLive.Index, :edit

    live "/api_keys/:id", ApiKeyLive.Show, :show
    live "/api_keys/:id/show/edit", ApiKeyLive.Show, :edit


    live "/prompts", PromptLive.Index, :index
    live "/prompts/new", PromptLive.Index, :new
    live "/prompts/:id/edit", PromptLive.Index, :edit

    live "/prompts/:id", PromptLive.Show, :show
    live "/prompts/:id/show/edit", PromptLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", FastllmcppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:fastllmcpp, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FastllmcppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
