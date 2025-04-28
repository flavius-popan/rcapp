defmodule Rcapp.Dbserver do
  @moduledoc """
  Runs a server on http://localhost:4000/.

  When the server receives a request on http://localhost:4000/set?somekey=somevalue
  it stores the passed key and value in memory using `Dbagent`.

  When it receives a request on http://localhost:4000/get?key=somekey
  it returns the value stored at `somekey`.
  """
  use Plug.Router
  alias Dbagent

  require IEx

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  get "/get" do
    # IEx.pry()
    # _key would be "key" in 'http://localhost:4000/get?key=somekey'
    [_key, key] = String.split(conn.query_string, "=")
    value = Dbagent.get(key)
    send_resp(conn, 200, to_string(value) <> "\n")
  end

  get "/set" do
    # IEx.pry()
    [key, value] = String.split(conn.query_string, "=")
    Dbagent.set(key, value)
    send_resp(conn, 200, ":ok\n")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
