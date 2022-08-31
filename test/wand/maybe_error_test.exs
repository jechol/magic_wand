defmodule Wand.MaybeErrorTest do
  use Wand.Case

  alias Wand.MaybeError

  test "Atom" do
    assert %Error{raw: :error} = :error |> MaybeError.wrap()

    assert :other = :other |> MaybeError.wrap()
  end

  test "Tuple" do
    assert %Error{raw: {:error, :some_error}} = {:error, :some_error} |> MaybeError.wrap()

    assert 100 == {:ok, 100} |> MaybeError.wrap()

    assert %Error{raw: {:ok, {:error, :some_error}}} =
             {:ok, {:error, :some_error}} |> MaybeError.wrap()
  end

  test "RawError" do
    assert %Error{raw: :x, reason: :x, details: nil} = %RawError{raw: :x} |> MaybeError.wrap()

    assert %Error{raw: {:x, :y}, reason: :x, details: :y} =
             %RawError{raw: {:x, :y}} |> MaybeError.wrap()

    assert %Error{raw: 100, reason: nil, details: nil} = %RawError{raw: 100} |> MaybeError.wrap()
  end

  test "Error" do
    assert %Error{raw: :some_error} == %Error{raw: :some_error} |> MaybeError.wrap()
  end

  test "Tesla.Env" do
    assert %Tesla.Env{status: 300} = %Tesla.Env{status: 300} |> MaybeError.wrap()
    assert %Error{raw: %Tesla.Env{status: 400}} = %Tesla.Env{status: 400} |> MaybeError.wrap()
  end

  test "Any" do
    assert 100 == 100 |> MaybeError.wrap()
  end
end
