defmodule Wand.Safe do
  use Wand.Error

  defmacro __using__([]) do
    quote do
      use Wand.Error
      alias Wand.Safe
      alias Wand.Stacktrace
    end
  end

  defmacro guard(do: dangerous) do
    alias __MODULE__

    quote do
      Safe.do_guard(fn -> unquote(dangerous) end)
    end
  end

  defmacro guard(dangerous) do
    alias __MODULE__

    quote do
      Safe.do_guard(fn -> unquote(dangerous) end)
    end
  end

  def do_guard(dangerous_fn) do
    try do
      dangerous_fn.() |> MaybeError.wrap()
    rescue
      exception ->
        stacktrace = __STACKTRACE__ |> Error.filter_stacktrace()

        %Error{
          raw: exception,
          reason: :exception_raised,
          details: exception,
          stacktrace: stacktrace
        }
    end
  end
end
