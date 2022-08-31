defmodule MagicWand.Nillable do
  def map(nil, f) when is_function(f) do
    nil
  end

  def map(non_nil, f) when is_function(f) do
    f.(non_nil)
  end

  def fallback(nil, fallback), do: fallback

  def fallback(non_nil, _), do: non_nil
end
