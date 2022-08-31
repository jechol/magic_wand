defmodule Wand.Traversable do
  alias Algae.Either.{Left, Right}

  defmodule EitherList do
    def traverse([]) do
      Right.new([])
    end

    def traverse(traversable) when is_list(traversable) do
      Witchcraft.Traversable.traverse(traversable, & &1)
    end
  end

  defmodule WriterList do
    def traverse([]) do
      Algae.Writer.new([], [])
    end

    def traverse(traversable) when is_list(traversable) do
      Witchcraft.Traversable.traverse(traversable, & &1)
    end
  end

  defmodule ReatherList do
    def traverse(traversable) when is_list(traversable) do
      Reather.new(fn env ->
        traversable
        |> Enum.map(fn %Reather{} = r ->
          r |> Reather.run(env)
        end)
        |> EitherList.traverse()
      end)
    end
  end

  defmodule ReatherMap do
    def traverse(%{} = map) do
      Reather.new(fn env ->
        map
        |> Enum.map(fn {k, v} ->
          case v |> Reather.run(env) do
            %Right{right: right} -> Right.new({k, right})
            %Left{left: left} -> left
          end
        end)
        |> EitherList.traverse()
        |> Witchcraft.Functor.map(fn list -> list |> Enum.into(%{}) end)
      end)
    end
  end
end
