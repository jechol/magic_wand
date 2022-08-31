defmodule MagicWand.TraversableTest do
  use MagicWand.Case

  test "EitherList" do
    assert_right [] == [] |> EitherList.traverse()

    assert_right [1, 2, 3] ==
                   [%Right{right: 1}, %Right{right: 2}, %Right{right: 3}]
                   |> EitherList.traverse()

    assert %Left{left: :some_err} ==
             [%Right{right: 1}, %Left{left: :some_err}, %Right{right: 3}]
             |> EitherList.traverse()
  end

  test "WriterList" do
    assert Writer.new([], []) == [] |> WriterList.traverse()

    # Caution: log order is not reserved. Not [1,2,3]
    assert Writer.new([1, 2, 3], [2, 3, 1]) ==
             [Writer.new(1, [1]), Writer.new(2, [2, 3]), Writer.new(3, [])]
             |> WriterList.traverse()
  end

  test "ReatherList" do
    assert %Right{right: []} == [] |> ReatherList.traverse() |> Reather.run()

    assert %Right{right: [1, 2, 3]} ==
             [%Right{right: 1}, %Right{right: 2}, %Right{right: 3}]
             |> Enum.map(&Reather.of/1)
             |> ReatherList.traverse()
             |> Reather.run()

    assert %Left{left: :some_err} ==
             [%Right{right: 1}, %Left{left: :some_err}, %Right{right: 3}]
             |> Enum.map(&Reather.of/1)
             |> ReatherList.traverse()
             |> Reather.run()
  end
end
