defmodule MagicWand do
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

      use MagicWand.StrictIf
      use MagicWand.Error
      use MagicWand.Monad

      alias MagicWand.Traversable.{EitherList, WriterList, ReatherList, ReatherMap}
      alias MagicWand.Nillable
      alias MagicWand.Async
      alias MagicWand
    end
  end
end
