defmodule MagicWand.Application do
  use Application

  def start(_type, _arguments) do
    children = [
      {Task.Supervisor, name: MagicWand.TaskSupervisor}
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
