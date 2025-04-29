defmodule Dbagent do
  @moduledoc """
  Provides an in-memory key-value store using the OTP Agent Behaviour.

  ## Examples

      # FYI: Dbagent is started by the application supervisor when running `mix test`
      iex> Dbagent.set("somekey", "somevalue")
      :ok
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
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def set(key, value) do
    Agent.cast(__MODULE__, &Map.put(&1, key, value))
  end
end
