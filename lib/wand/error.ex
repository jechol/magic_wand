defmodule Wand.Error do
  alias __MODULE__

  defmacro __using__([]) do
    quote do
      alias Wand.Error
      alias Wand.ErrorSrc
      alias Wand.MaybeError
      alias Wand.Error.RawError
    end
  end

  defmodule RawError do
    defstruct [:raw]
  end

  defstruct [:raw, :reason, :details, :stacktrace]

  defmacro new(raw, reason, details) do
    # This should be macro to prevent stack replacement.
    # If not, last frame will be replaced by Error.new/1 if it was last expression of the function.
    quote do
      %Error{
        raw: unquote(raw),
        reason: unquote(reason),
        details: unquote(details),
        stacktrace: Wand.Error.get_filtered_stacktrace()
      }
      |> Wand.ErrorLogger.log_error()
    end
  end

  def get_filtered_stacktrace() do
    {:current_stacktrace, trace} = Process.info(self(), :current_stacktrace)
    trace |> filter_stacktrace()
  end

  def filter_stacktrace(trace) do
    trace
    |> Enum.filter(fn {m, _f, _a, _file} ->
      run_loop_module? = m in [Process, :erl_eval, :elixir, IEx.Evaluator]

      control_module? = m in [Wand.Error, Wand.MaybeError, Wand.Monad, Wand.Safe]

      maybe_error_impl? = match?("Elixir.Wand.MaybeError." <> _, m |> Atom.to_string())

      not (run_loop_module? or control_module? or maybe_error_impl?)
    end)
  end
end
