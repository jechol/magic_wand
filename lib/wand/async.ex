defmodule Wand.Async do
  def map(enumerable, func) do
    map(enumerable, func, :erlang.system_info(:schedulers) * 16)
  end

  def map(enumerable, func, max_concurrency) when is_integer(max_concurrency) do
    chunk_size = div(Enum.count(enumerable) - 1, max_concurrency) + 1

    enumerable
    |> Enum.chunk_every(chunk_size)
    |> Enum.map(fn chunks ->
      Task.Supervisor.async(Wand.TaskSupervisor, fn ->
        chunks |> Enum.map(func)
      end)
    end)
    |> Task.await_many(:infinity)
    |> Enum.flat_map(& &1)
  end
end
