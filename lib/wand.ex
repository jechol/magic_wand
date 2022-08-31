defmodule Wand do
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

      use Wand.StrictIf
      use Wand.Error
      use Wand.Monad

      alias Wand.Traversable.{EitherList, WriterList, ReatherList, ReatherMap}
      alias Wand.Nillable
      alias Wand.Async
      alias Wand
    end
  end
end
