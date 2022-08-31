defmodule Wand.StrictIfTest do
  use Wand.Case

  def div_10_by(n) do
    10 / n
  end

  def equal?(a, b), do: a == b

  describe "strict_if/3" do
    test "true" do
      assert :ok == strict_if(equal?(1, 1), do: :ok, else: :error)
    end

    test "false" do
      assert :error == strict_if(equal?(1, 2), do: :ok, else: :error)
    end

    test "non boolean" do
      assert_raise StrictIfException, fn -> strict_if(nil, do: :ok, else: :error) end
      assert_raise StrictIfException, fn -> strict_if([], do: :ok, else: :error) end
    end
  end

  describe "strict_if/2" do
    test "true" do
      assert :ok == strict_if(equal?(1, 1), do: :ok)
    end

    test "false" do
      assert nil == strict_if(equal?(1, 2), do: :ok)
    end

    test "non boolean" do
      assert_raise StrictIfException, fn -> strict_if(nil, do: :ok) end
      assert_raise StrictIfException, fn -> strict_if([], do: :ok) end
    end
  end
end
