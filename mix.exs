defmodule Category.MixProject do
  use Mix.Project

  def project do
    [
      app: :category,
      version: "VERSION" |> File.read!() |> String.trim(),
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      # excoveralls
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.travis": :test,
        "coveralls.circle": :test,
        "coveralls.semaphore": :test,
        "coveralls.post": :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ],
      # dialyxir
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore",
        plt_add_apps: [
          :mix,
          :ex_unit
        ]
      ],
      # ex_doc
      name: "Category",
      source_url: "https://github.com/timCF/category",
      homepage_url: "https://github.com/timCF/category",
      docs: [main: "readme", extras: ["README.md"]],
      # hex.pm stuff
      description: "Functors, Monads and Applicatives with real encapsulation",
      package: [
        licenses: ["MIT"],
        files: ["lib", "priv", "mix.exs", "README*", "VERSION*"],
        maintainers: ["ILJA TKACHUK aka timCF"],
        links: %{
          "GitHub" => "https://github.com/timCF/category",
          "Author's home page" => "https://itkach.uk"
        }
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
      {:calculus, "~> 0.1.3"},
      {:kare, "~> 1.0"},
      # development tools
      {:excoveralls, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev, :test], runtime: false},
      {:credo, "~> 0.9", only: [:dev, :test], runtime: false},
      {:boilex, "~> 0.2", only: [:dev, :test], runtime: false},
      {:benchfella, "~> 0.3.5", only: :bench, runtime: false}
    ]
  end

  defp aliases do
    [
      docs: ["docs", "cmd mkdir -p doc/priv/img/", "cmd cp -R priv/img/ doc/priv/img/", "docs"]
    ]
  end
end
