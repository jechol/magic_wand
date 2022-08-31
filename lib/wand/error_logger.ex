defmodule Wand.ErrorLogger do
  require Logger
  alias Wand.Error

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
    Application.get_env(:wand, :logging_error, false)
  end
end
