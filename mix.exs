defmodule Freight.MixProject do
  use Mix.Project

  def project do
    [
      app: :freight,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:absinthe, "~> 1.3"}
    ]
  end

  defp description do
    "Dynamically create Absinthe GraphQL payload objects for mutations 🚚💨"
  end

  defp package do
    [
      # These are the default files included in the package
      files: ~w(lib priv .formatter.exs mix.exs README.md LICENSE CHANGELOG.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Nickforall/Freight"}
    ]
  end
end
