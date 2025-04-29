defmodule DbserverTest do
  use ExUnit.Case

  # NOTE: These tests will fail if server is already running on http://localhost:4000!
  # You must shut it down before running tests as `mix test` will start one up.

  describe "Core Functional Requirements" do
    test "/set & /get work as expected" do
      # Generate unique test keys per run, just in case.
      key = "test-key-#{System.unique_integer()}"
      value = "test-value-#{System.unique_integer()}"

      # Test /set
      set_url = "http://localhost:4000/set?#{key}=#{value}"
      {_set_output, set_exit_status} = System.cmd("curl", ["-s", set_url])
      assert set_exit_status == 0, "curl command for /set failed"

      # Test /get
      get_url = "http://localhost:4000/get?key=#{key}"
      {get_output, get_exit_status} = System.cmd("curl", ["-s", get_url])
      assert get_exit_status == 0, "curl command for /get failed"
      assert String.trim(get_output) == value
    end

    test "/get?key= returns empty for non-existent key" do
      key = "nonexistent-test-key-#{System.unique_integer()}"

      # Test getting a non-existent value
      get_url = "http://localhost:4000/get?key=#{key}"
      {get_output, get_exit_status} = System.cmd("curl", ["-s", get_url])
      assert get_exit_status == 0, "curl command for /get failed"
      assert String.trim(get_output) == ""
    end
  end

  describe "Persistence" do
    @tag :capture_log
    test "key-value pair persists after server restart" do
      key = "persist-key-#{System.unique_integer()}"
      value = "persist-value-#{System.unique_integer()}"

      # /set
      set_url = "http://localhost:4000/set?#{key}=#{value}"
      {_set_output, set_exit_status} = System.cmd("curl", ["-s", "--fail", set_url])
      assert set_exit_status == 0, "curl command for /set failed"

      # Stop then restart the application
      :ok = Application.stop(:rcapp)
      {:ok, _} = Application.ensure_all_started(:rcapp)

      # /get
      get_url = "http://localhost:4000/get?key=#{key}"
      {get_output, get_exit_status} = System.cmd("curl", ["-s", "--fail", get_url])

      assert get_exit_status == 0, "curl command for /get after restart failed"

      assert String.trim(get_output) == value,
             "Value did not persist after restart. Expected '#{value}', got '#{String.trim(get_output)}'"
    end
  end
end
