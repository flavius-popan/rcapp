defmodule Dbagent do
  @moduledoc """
  Provides an in-memory key-value store using Agent.

  This module can be used as the storage backend for a web server
  that needs to store key-value pairs based on HTTP requests,
  such as setting a value via `/set?somekey=somevalue` and retrieving
  it via `/get?key=somekey`.

  ## Examples

      iex> {:ok, _pid} = Dbagent.start_link(%{})
      iex> # Simulate storing a value like from /set?somekey=somevalue
      iex> Dbagent.set("somekey", "somevalue")
      :ok
      iex> # Simulate retrieving a value like for /get?key=somekey
      iex> Dbagent.get("somekey")
      "somevalue"
      iex> Dbagent.get("anotherkey")
      nil
  """
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key, ":nil"))
  end

  def set(key, value) do
    Agent.cast(__MODULE__, &Map.put(&1, key, value))
  end
end
