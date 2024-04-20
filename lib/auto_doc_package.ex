defmodule AutoDocPackage do
  @moduledoc """
  The package "AutoDocPackage" is used by the "Auto Doc" microservice
  for generating API documentation based on OpenApiSpex format for Elixir projects.

  This package handles the transmission of data
  between the `AutoDoc` microservice and your Elixir project.
  It also generates the API Documentation directories and files filled with data,
  nested inside the respected `/documentation` directory.

  ## Prerequisites
  The package requires `:jason` and `:httpoison` to run while your project requires `:open_api_spex` as a documentation tool.

  - Dependencies:
    - `[:jason](https://hexdocs.pm/jason/Jason.html)`
    - `[:httpoison](https://hexdocs.pm/httpoison/HTTPoison.html)`
    - `[:open_api_spex](https://hexdocs.pm/open_api_spex/3.4.0/readme.html)`

  ## Installation
  Add `auto_doc_package` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:auto_doc_package, "~> 0.1.1"}
      ]
    end
    ```

  ## Extra Info
  - A complete guide on registration and usage can be found in our [Github README](https://github.com/zen-dev-lab/auto_doc_package?tab=readme-ov-file#auto-doc-effortless-openapispex-documentation).
  - The package is licensed under [CC-BY-NC-ND-4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/).
  - The product "Auto Doc" is hosted at [auto-doc.fly.dev](https://auto-doc.fly.dev).
  - The microservice itself works on a subscription basis.
  - The monthly subscription fee is 10€.
  - The product is currently in its initial phase and is being actively developed.
  """
end
