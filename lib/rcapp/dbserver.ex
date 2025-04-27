defmodule Rcapp.Dbserver do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  get "/get" do
    send_resp(conn, 200, "get")
  end

  get "/set" do
    send_resp(conn, 200, "set")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
