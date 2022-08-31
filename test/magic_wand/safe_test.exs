defmodule MagicWand.SafeTest do
  use MagicWand.Case

  defmodule CustomException do
    defexception [:code, :message]
  end

  def boom!() do
    raise %CustomException{code: :explode, message: "bang!"}
  end

  def my_div(a, b) do
    a / b
  end

  describe "guard" do
    test "raise from code" do
      assert %Error{
               raw: %CustomException{code: :explode, message: "bang!"},
               stacktrace: [
                 {MagicWand.SafeTest, :boom!, 0, [_file, _line, _error_info]} | _
               ]
             } = boom!() |> Safe.guard()
    end

    test "raise from runtime" do
      assert %Error{
               raw: %ArithmeticError{},
               stacktrace: [{MagicWand.SafeTest, :my_div, 2, [_file, _line]} | _]
             } = my_div(6, 0) |> Safe.guard()
    end

    test "error tuple/struct" do
      # tagged error
      assert %Error{raw: :error} = Safe.guard(:error)
      assert %Error{raw: {:error, :boom}} = Safe.guard({:error, :boom})

      # %Error{}
      assert %Error{raw: :boom} = Safe.guard(%Error{raw: :boom})
    end

    test "no error" do
      assert 3.0 == my_div(6, 2) |> Safe.guard()
      assert false == false |> Safe.guard()
      assert nil == nil |> Safe.guard()
    end
  end
end
