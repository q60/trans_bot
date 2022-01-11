defmodule TransBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :trans_bot,
      version: "0.9.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [
        main_module: TransBot
      ]
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
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:balalaika_bear, git: "https://github.com/q60/balalaika_bear"},
      {:ecto, "~> 3.7"}
    ]
  end
end
