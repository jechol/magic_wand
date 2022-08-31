defmodule Wand.Monad do
  use Wand.Safe
  use Wand.StrictIf

  alias Algae.Either.{Left, Right}
  alias Algae.Maybe

  alias Witchcraft.{Applicative, Functor}
  alias __MODULE__

  defmacro __using__([]) do
    quote do
      # When kernel is overridden, cannot use <, >, <=, >= in guard clause.
      use Wand.Safe
      use Wand.StrictIf
      use Witchcraft, override_kernel: false, except: [then: 2, sequence: 1, equal?: 2]

      alias Algae.{Either, Maybe, State, Writer}

      alias Algae.Either.{Left, Right}
      alias Algae.Maybe.{Just, Nothing}
      import Algae.Writer, only: [writer: 1]

      alias Witchcraft.{Applicative, Functor, Traversable}

      alias Wand.Monad
    end
  end

  defmacro either(do: dangerous) do
    quote do
      Monad.do_either(fn -> unquote(dangerous) end)
    end
  end

  defmacro either(dangerous) do
    quote do
      Monad.do_either(fn -> unquote(dangerous) end)
    end
  end

  def do_either(dangerous_fn) do
    case Safe.guard(dangerous_fn.()) do
      %Left{} = left -> left
      %Right{} = right -> right
      %Error{} = e -> Left.new(e)
      value -> Right.new(value)
    end
  end

  defmacro left_error(error) do
    quote do
      %RawError{raw: unquote(error)} |> MaybeError.wrap() |> Left.new()
    end
  end

  def unwrap_either(%Right{right: value}), do: value
  def unwrap_either(%Left{left: %Error{raw: raw}}), do: raise(RuntimeError, raw |> inspect())
  def unwrap_either(%Left{left: error}), do: raise(RuntimeError, error |> inspect())

  defmacro confirm(confirmed?, error) do
    quote do
      Monad.either do
        strict_if(unquote(confirmed?), do: Right.new(:ok), else: Monad.left_error(unquote(error)))
      end
    end
  end
end
