defmodule Datcord.Mixfile do
  use Mix.Project

  def project do
    [app: :datcord,
     version: "0.2.3",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :crypto, :ssl]]
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
    [{:poison, "~> 1.5"},
     {:websocket_client, github: "jeremyong/websocket_client"},
     {:httpoison, "~> 0.8.0"},
     {:credo, "~> 0.2.5", only: [:dev, :test]},
     {:dialyze, "~> 0.2.0", only: :dev}]
  end
end
