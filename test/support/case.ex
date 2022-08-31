defmodule Anvil.Case do
  use ExUnit.CaseTemplate

  using(opts) do
    {async, []} = opts |> Keyword.pop(:async, true)

    quote do
      use ExUnit.Case, async: unquote(async)
      use Anvil
      import Anvil.MonadAssertions
      import Anvil.MapMatcher
    end
  end
end
