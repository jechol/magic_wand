defmodule Anvil.MonadTest do
  use Anvil.Case

  describe "either/1" do
    test "Right" do
      assert_right :good = Monad.either(:good)
      assert_right :monad! = Monad.either(Quark.id(:monad!))
      assert_right %Just{just: 10} = %Just{just: 10} |> Monad.either()
      assert_right %Nothing{} = %Nothing{} |> Monad.either()

      assert_right :good =
                     (Monad.either do
                        Process.sleep(1)
                        :good
                      end)
    end

    test "Left" do
      assert_left_error {:error, :boom} = Monad.either({:error, :boom})

      assert_left_error %RuntimeError{message: "boom"} = raise("boom") |> Monad.either()
    end
  end

  describe "confirm/2" do
    test "true" do
      assert_right :ok = (10 / 3 > 3) |> Monad.confirm(:some_error)
    end

    test "false" do
      assert_left_error :some_error = (10 / 3 < 3) |> Monad.confirm(:some_error)
    end

    test "non boolean" do
      assert_left_error %StrictIfException{value: 10} = 10 |> Monad.confirm(:some_error)
      assert_left_error %StrictIfException{value: nil} = nil |> Monad.confirm(:some_error)
    end
  end
end
