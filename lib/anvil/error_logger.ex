defmodule Anvil.ErrorLogger do
  require Logger
  alias Anvil.Error

  def log_error(%Error{reason: reason, details: details, stacktrace: stacktrace} = error) do
    if logging_error?() do
      Logger.error(
        reason: reason,
        details: details,
        stacktrace: Exception.format_stacktrace(stacktrace) |> String.trim()
      )
    end

    error
  end

  defp logging_error?() do
    Application.get_env(:anvil, :logging_error)
  end
end
