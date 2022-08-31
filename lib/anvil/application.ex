defmodule Anvil.Application do
  use Application

  def start(_type, _arguments) do
    IO.puts("Stargin..")

    children = [
      {Task.Supervisor, name: Anvil.TaskSupervisor}
    ]

    options = [
      name: __MODULE__,
      strategy: :one_for_one,
      max_seconds: 1,
      max_restarts: 1000
    ]

    Supervisor.start_link(children, options)
  end
end
