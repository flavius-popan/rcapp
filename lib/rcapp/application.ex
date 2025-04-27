defmodule Rcapp.Application do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Rcapp.Dbserver, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: Rcapp.Supervisor]

    Logger.info("Starting DB Server...")

    Supervisor.start_link(children, opts)
  end
end
