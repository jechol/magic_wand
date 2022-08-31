defmodule Anvil.StrictIf do
  defmodule StrictIfException do
    defexception [:value, :message]
  end

  defmacro __using__([]) do
    quote do
      import Anvil.StrictIf, only: :macros
      alias Anvil.StrictIf.StrictIfException
    end
  end

  defmacro strict_if(expr, do: true_block, else: false_block) do
    quote do
      v = unquote(expr)

      if v in [true, false] do
        case v do
          true ->
            unquote(true_block)

          false ->
            unquote(false_block)
        end
      else
        raise %StrictIfException{
          value: v,
          message: "Expected true or false, but got #{v |> inspect}."
        }
      end
    end
  end

  defmacro strict_if(expr, do: true_block) do
    quote do
      strict_if(unquote(expr), do: unquote(true_block), else: nil)
    end
  end
end
