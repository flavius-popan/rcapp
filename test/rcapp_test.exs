defmodule RcappTest do
  use ExUnit.Case
  doctest Rcapp

  test "greets the world" do
    assert Rcapp.hello() == :world
  end
end
