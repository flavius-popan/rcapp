# Recurse Center Application - Pairing Task

I aspire to spend 12 weeks in Brooklyn making code dreams come true. 👨‍💻🌈

This repo contains code for the "Database Server" pairing task. See https://www.recurse.com/pairing-tasks for more details.

## Database Server

✅  Before your interview, write a program that runs a server that is accessible on http://localhost:4000/.

✅ When your server receives a request on `http://localhost:4000/set?somekey=somevalue` it should store the passed key and value in memory. When it receives a request on `http://localhost:4000/get?key=somekey` it should return the value stored at `somekey`.

☑️ During your interview, you will pair on saving the data to a file. You can start with simply appending each write to the file, and work on making it more efficient if you have time.

## For the interviewer 👋

Here's everything you need to know to get up to speed ASAP:

- This project uses the [`plug_cowboy`](https://github.com/elixir-plug/plug_cowboy) library to create a simple HTTP server. [`Cowboy`](https://github.com/ninenines/cowboy) is a minimal web server for Erlang/OTP, and [`Plug`](https://github.com/elixir-plug/plug) is a specification and set of utilities for building composable modules in Elixir. The server listens on port 4000 and handles requests to set and get key-value pairs as requested.
- The server stores key-value pairs in memory using an `Agent`. An `Agent` is a simple abstraction for stateful computations in Elixir. It allows us to manage state in a concurrent environment without having to worry about low-level details like locks or threads.

### Files of importance

- [Dbserver](https://github.com/flavius-popan/rcapp/blob/main/lib/rcapp/dbserver.ex) - HTTP router with `/set` and `/get` routes.
- [Dbagent](https://github.com/flavius-popan/rcapp/blob/main/lib/rcapp/dbagent.ex) - Agent that stores key-value pairs in memory.
- [dbserver_tests](https://github.com/flavius-popan/rcapp/blob/main/test/dbserver_test.exs) - Tests the HTTP server and the Agent using `curl` commands.

### Running the server

Run `mix run --no-halt` in the terminal to start the server, then use `curl` to test it:

```bash
curl 'http://localhost:4000/set?somekey=somevalue'
:ok
curl 'http://localhost:4000/get?key=somekey'
somevalue
curl 'http://localhost:4000/get?key=nilkey'

```

### The Plan 🤔

For our pairing session, I plan to write the internal state of the `Dbagent` to a file only on `set` requests, as `set` requests are casts and therefore won't block the client.

Since the `Dbagent` is [initialized using an empty map](https://github.com/flavius-popan/rcapp/blob/39eef46dbc02a811c1b36f3f013a73a540df7955/lib/rcapp/application.ex#L11), it should be fairly straightforward to save the map as binary file using `:erlang.term_to_binary`. I then plan to write a helper function that will check for the existence of this file during application startup, and use it if found via `:erlang.binary_to_term`, otherwise init with an empty map. This way, we can persist the state of the `Dbagent` across server restarts!
