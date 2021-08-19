defmodule Graphmex.MixProject do
  use Mix.Project

  def project do
    [
      app: :graphmex,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]],
      # Hex
      description:
        "A Mix Task to generate a relationship graph of your project modules using the DOT language",
      package: package(),
      # Docs
      name: "GraphMe",
      docs: fn ->
        {result, _} = Code.eval_file("docs.exs")
        result
      end
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
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Shiryel"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/shiryel/graphme"},
      files: ~w(.formatter.exs mix.exs docs.exs README.md lib)
    ]
  end
end
