defmodule PinElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :pin_elixir,
     version: "0.0.1",
     elixir: "~> 1.1",
     name: "PinElixir",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     description: description,
     deps: deps,
     docs: [extras: ["README.md"]]
     ]
  end

  def application do
    [applications: [:logger, :httpotion],
     mod: {PinElixir, []}]
  end

  defp deps do
    [
      {:httpotion, "~> 2.1.0"},
      {:hypermock, "~> 0.0.1", github: "mfeckie/hypermock", branch: "feature/extend-macro", only: :test},
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:poison, "~> 1.5"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.10", only: :dev}
    ]
  end

  defp description do
  """
  A library to wrap the Pin Payments API
  """
  end

  defp package do
    [
      maintainers: ["Martin Feckie"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/mfeckie/pin_elixir",
        "Docs" => "http://hexdocs.pm/pin_elixir/0.0.1/extra-api-reference.html"
      }
    ]
  end


end
