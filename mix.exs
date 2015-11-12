defmodule PinElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :pin_elixir,
     version: "0.0.1",
     elixir: "~> 1.1",
     name: "PinElixir",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     docs: [extras: ["README.md"], main: "extra-readme"]
     ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion],
     mod: {PinElixir, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpotion, "~> 2.1.0"},
      {:hypermock, "~> 0.0.2", only: :test},
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:poison, "~> 1.5"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.10", only: :dev}
    ]
  end
end
