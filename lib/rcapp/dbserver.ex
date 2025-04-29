defmodule Rcapp.Dbserver do
  @moduledoc """
  Runs a server on http://localhost:4000/.

  When the server receives a request on http://localhost:4000/set?somekey=somevalue
  it stores the passed key and value in memory using `Dbagent`.

  When it receives a request on http://localhost:4000/get?key=somekey
  it returns the value stored at `somekey`.

  Pro-tip: Use `require IEx` + `IEx.pry()` to save your bacon.
  """
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Use the /set?somekey=somevalue & /get?key=somekey routes!")
  end

  get "/get" do
    # _key_header would likely just be 'key' for this endpoint
    [_key_header, key] = String.split(conn.query_string, "=")
    value = Dbagent.get(key)
    send_resp(conn, 200, to_string(value) <> "\n")
  end

  get "/set" do
    [key, value] = String.split(conn.query_string, "=")
    Dbagent.set(key, value)
    send_resp(conn, 200, ":ok\n")
  end

  match _ do
    send_resp(conn, 404, "womp womp, no can do.")
  end
end
