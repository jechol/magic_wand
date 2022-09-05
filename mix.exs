defmodule MagicWand.MixProject do
  use Mix.Project

  def project do
    [
      app: :magic_wand,
      version: "0.2.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "MagicWand",
      source_url: "https://github.com/jechol/magic_wand"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MagicWand.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mok, ">= 0.0.0"},
      {:reather, ">= 0.0.0"},
      {:tesla, ">= 0.0.0"},
      {:jason, ">= 0.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "MagicWand is toolkit to use Witchcraft and Reather more easily."
  end

  defp package() do
    [
      name: "magic_wand",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jechol/magic_wand"}
    ]
  end
end
