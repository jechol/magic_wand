defmodule Anvil.MapMatcher do
  defmacro assert_map_match({:=, _, [left, right]}) do
    import ExUnit.Assertions

    quote bind_quoted: [left: left, right: right] do
      assert not Map.has_key?(left, :__struct__) or
               Map.get(left, :__struct__) == Map.get(right, :__struct__)

      left_map = left |> normalize_to_map()
      right_map = right |> normalize_to_map() |> Map.take(left |> Map.keys())

      assert left_map == right_map
    end
  end

  defmacro refute_map_match({:=, _, [left, right]}) do
    import ExUnit.Assertions

    quote bind_quoted: [left: left, right: right] do
      left_map = left |> normalize_to_map()
      right_map = right |> normalize_to_map() |> Map.take(left |> Map.keys())

      refute left_map == right_map and
               (not Map.has_key?(left, :__struct__) or
                  Map.get(left, :__struct__) == Map.get(right, :__struct__))
    end
  end

  def normalize_to_map(%{} = map_or_struct) do
    if is_struct(map_or_struct) do
      map_or_struct |> Map.from_struct()
    else
      map_or_struct
    end
  end
end
