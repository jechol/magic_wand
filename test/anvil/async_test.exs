defmodule Anvil.AsyncTest do
  use Anvil.Case

  test "map/2" do
    check_less_than_10 = fn
      n when n < 10 ->
        Right.new(n)

      _ ->
        Left.new(:out_of_range)
    end

    slow_check_less_than_10 = fn n ->
      Process.sleep(10)
      check_less_than_10.(n)
    end

    assert 0..19 |> Enum.map(check_less_than_10) ==
             0..19 |> Async.map(slow_check_less_than_10)
  end
end
