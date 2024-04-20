defmodule AutoDocPackage.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/zen-dev-lab/auto_doc_package"
  @homepage_url "https://auto-doc.fly.dev"

  def project do
    [
      app: :auto_doc_package,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Auto Doc",
      source_url: @source_url,
      homepage_url: @homepage_url
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
      {:jason, "~> 1.2"},
      {:httpoison, "~> 2.2"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    The package "AutoDocPackage" is used by the "Auto Doc" microservice
    for generating API documentation based on OpenApiSpex format for Elixir projects.
    and generate the API Docs directories and files filled with data,
    nested inside the respected `/documentation` directory.
    """
  end

  defp package() do
    [
      name: "auto_doc_packagee",
      # These are the default files included in the package
      files:
        ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE* license* CHANGELOG* changelog* src),
      licenses: ["CC-BY-NC-ND-4.0"],
      links: %{"GitHub" => "https://github.com/zen-dev-lab/auto_doc_package"}
    ]
  end
end
