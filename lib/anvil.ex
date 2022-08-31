defmodule Anvil do
  defmacro __using__([]) do
    %Macro.Env{module: mod, function: fun} = __CALLER__

    use_reather =
      if mod != nil and fun == nil do
        quote do
          use Reather
        end
      else
        quote do
        end
      end

    quote do
      unquote(use_reather)

      require Logger
      require Mok

      use Anvil.StrictIf
      use Anvil.Error
      use Anvil.Monad

      alias Anvil.Traversable.{EitherList, WriterList, ReatherList, ReatherMap}
      alias Anvil.Nillable
      alias Anvil.Async
      alias Anvil
    end
  end
end
