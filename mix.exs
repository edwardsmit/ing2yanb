defmodule Ing2ynab.MixProject do
  use Mix.Project

  def project do
    [
      app: :ing2ynab,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: Ing2ynab]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [applications: [:timex], extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_csv, "~> 1.0"},
      {:timex, "~> 3.5"}
    ]
  end
end
