defmodule Wand.Case do
  use ExUnit.CaseTemplate

  using(opts) do
    {async, []} = opts |> Keyword.pop(:async, true)

    quote do
      use ExUnit.Case, async: unquote(async)
      use Wand
      import Wand.MonadAssertions
      import Wand.MapMatcher
    end
  end
end
