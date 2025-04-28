defmodule Rcapp.Application do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # server
      {Plug.Cowboy, scheme: :http, plug: Rcapp.Dbserver, options: [port: 4000]},
      # state agent
      {Dbagent, %{}}
    ]

    opts = [strategy: :one_for_one, name: Rcapp.Supervisor]

    Logger.info("Starting DB Server & Agent...")

    Supervisor.start_link(children, opts)
  end
end
