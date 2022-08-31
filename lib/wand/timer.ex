defmodule MagicWand.Timer do
  defmacro __using__([]) do
    quote do
      require unquote(__MODULE__)
      alias unquote(__MODULE__)
    end
  end

  defmacro measure(body, job \\ "anonymous") do
    quote do
      require Logger
      Logger.info("Job started : #{unquote(job)}")

      {time_us, value} = :timer.tc(fn -> unquote(body) end)
      time_ms = time_us |> div(1000)

      Logger.info("Job finished: #{unquote(job)} in #{time_ms} ms")
      value
    end
  end
end
