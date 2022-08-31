defmodule MagicWand.MonadAssertions do
  use MagicWand

  defmacro assert_right({operator, _, [left, right]}) when operator in [:=, :==] do
    quote do
      ExUnit.Assertions.assert(
        unquote(operator)(
          %Right{right: unquote(left)},
          unquote(right) |> MagicWand.MonadAssertions.run_if_reather()
        )
      )
    end
  end

  defmacro assert_left_error({:==, _, [left, right]}) do
    quote do
      ExUnit.Assertions.assert(
        %Left{left: %Error{raw: raw}} =
          unquote(right) |> MagicWand.MonadAssertions.run_if_reather()
      )

      ExUnit.Assertions.assert(unquote(left) == raw)
    end
  end

  defmacro assert_left_error({:=, _, [left, right]}) do
    quote do
      ExUnit.Assertions.assert(
        %Left{left: %Error{raw: unquote(left)}} =
          unquote(right) |> MagicWand.MonadAssertions.run_if_reather()
      )
    end
  end

  defmacro assert_just({operator, _, [left, right]}) when operator in [:=, :==] do
    quote do
      ExUnit.Assertions.assert(
        unquote(operator)(
          %Just{just: unquote(left)},
          unquote(right) |> MagicWand.MonadAssertions.run_if_reather()
        )
      )
    end
  end

  defmacro assert_nothing(expr) do
    quote do
      ExUnit.Assertions.assert(
        %Nothing{} = unquote(expr) |> MagicWand.MonadAssertions.run_if_reather()
      )
    end
  end

  defmacro setup_right({:=, _, [_left, _right]} = expr) do
    quote do
      assert_right(unquote(expr))
    end
  end

  defmacro setup_right(expr) do
    quote do
      setup_right(_ = unquote(expr))
    end
  end

  def run_if_reather(%Reather{} = r), do: r |> Reather.run()
  def run_if_reather(other), do: other
end
