defmodule MagicWand.Case do
  use ExUnit.CaseTemplate

  using(opts) do
    {async, []} = opts |> Keyword.pop(:async, true)

    quote do
      use ExUnit.Case, async: unquote(async)
      use MagicWand
      import MagicWand.MonadAssertions
      import MagicWand.MapMatcher
    end
  end
end
