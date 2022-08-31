defprotocol Anvil.MaybeError do
  @doc "Wrap with %Error{} if error value"
  @fallback_to_any true
  def wrap(data)
end

require Logger
require Mok

use Anvil.StrictIf
use Anvil.Error
use Anvil.Monad

defimpl MaybeError, for: Atom do
  def wrap(:error), do: Error.new(:error, nil, nil)
  def wrap(other), do: other
end

defimpl MaybeError, for: Tuple do
  def wrap({:error, reason} = raw) when is_atom(reason), do: Error.new(raw, reason, nil)

  def wrap({:error, {reason, details}} = raw) when is_atom(reason),
    do: Error.new(raw, reason, details)

  def wrap({:error, %Error{} = error}) do
    error
  end

  def wrap({:error, details} = raw) do
    case details |> MaybeError.wrap() do
      %Error{raw: ^details} = err -> %Error{err | raw: raw}
      ^details -> Error.new(raw, nil, details)
    end
  end

  def wrap({:ok, value}) do
    case value |> MaybeError.wrap() do
      %Error{raw: ^value} = err -> %Error{err | raw: {:ok, value}}
      non_error -> non_error
    end
  end

  def wrap(other), do: other
end

defimpl MaybeError, for: RawError do
  def wrap(%RawError{raw: raw}) do
    case raw |> MaybeError.wrap() do
      %Error{raw: ^raw} = err ->
        err

      ^raw ->
        case raw do
          {reason, details} when is_atom(reason) -> Error.new(raw, reason, details)
          reason when is_atom(reason) -> Error.new(raw, reason, nil)
          non_atom -> Error.new(non_atom, nil, nil)
        end
    end
  end
end

defimpl MaybeError, for: Error do
  def wrap(err), do: err
end

defimpl MaybeError, for: Tesla.Env do
  def wrap(%Tesla.Env{status: status} = env) when status >= 400 do
    Error.new(env, :tesla, decode_tesla_error(env))
  end

  def wrap(other), do: other

  defp decode_tesla_error(%Tesla.Env{headers: headers, body: body}) do
    if Enum.any?(headers, fn {k, v} -> k == "content-type" and String.contains?(v, "json") end) do
      body |> Jason.decode!()
    else
      body
    end
  end
end

defimpl MaybeError, for: Anvil.Gcp.GcpException do
  def wrap(exception), do: Error.new(exception, :gcp, exception)
end

defimpl MaybeError, for: Any do
  def wrap(data), do: data
end
