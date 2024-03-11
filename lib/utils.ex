defmodule AutoDocPackage.Utils do
  @moduledoc """
  	Utilities for the AutoDoc package
  """

  @file_path_prefix "../"
  @pascal_case_regex ~r/\A(?:[A-Z][a-z0-9]*)+\z/
  @camel_case_regex ~r/\A[a-z][a-zA-Z0-9]*\z/
  @snake_case_regex ~r/\A[a-z]+(_[a-z]+)*\z/

  @doc """
  	Returns the name of the project container.

  	## Examples
  		iex> project_container_name()
  			"auto_doc"
  """
  def project_container_name, do: Path.absname("../") |> String.split("/") |> Enum.at(-2)

  @doc """
  	Converts a path to a module name.

  	## Examples
  		iex> path_to_module_name("auto_doc/lib/auto_doc/utils.ex")
  		"AutoDoc.Utils"

  		iex> path_to_module_name("auto_doc/test/auto_doc/utils_test.exs")
  		"AutoDoc.UtilsTest"
  """
  def path_to_module_name(path) when is_binary(path) do
    paths_to_remove = [
      "#{project_container_name()}/lib/",
      "#{project_container_name()}/test/",
      "controllers/",
      "views/"
    ]

    path
    |> String.replace(paths_to_remove, "")
    |> String.trim_trailing(".ex")
    |> String.trim_trailing(".exs")
    |> String.split("/")
    |> Enum.map(&to_pascal_case/1)
    |> Enum.join(".")
  end

  @doc """
  	Converts a module name to a path.

  	## Examples
  		iex> module_name_to_path("AutoDoc.Utils")
  		"auto_doc/lib/auto_doc/utils.ex"

  		iex> module_name_to_path("AutoDoc.UtilsTest")
  		"auto_doc/test/auto_doc/utils_test.exs"
  """
  def module_name_to_path(module_name, suffix \\ "ex") do
    category =
      cond do
        is_controller_module?(module_name) or is_controller_test_module?(module_name) ->
          "controllers"

        is_view_module?(module_name) or is_view_test_module?(module_name) ->
          "views"

        true ->
          ""
      end

    path =
      module_name
      |> String.split(".")
      |> List.insert_at(1, category)
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&to_snake_case/1)
      |> Enum.join("/")

    if is_test_module?(module_name),
      do: "#{project_container_name()}/test/#{path}.exs",
      else: "#{project_container_name()}/lib/#{path}.#{suffix}"
  end

  @doc """
  	Checks if a module name is a view module.

  	## Examples
  		iex> is_view_module?("AutoDoc.PageView")
  		true

  		iex> is_view_module?("AutoDoc.PageController")
  		false
  """
  def is_view_module?(module_name) when is_binary(module_name),
    do: String.match?(module_name, ~r/View\z/)

  @doc """
  	Checks if a module name is a controller module.

  	## Examples
  		iex> is_controller_module?("AutoDoc.PageController")
  		true

  		iex> is_controller_module?("AutoDoc.PageView")
  		false
  """
  def is_controller_module?(module_name) when is_binary(module_name),
    do: String.match?(module_name, ~r/Controller\z/)

  @doc """
  	Checks if a module name is a test module.

  	## Examples
  		iex> is_test_module?("AutoDoc.UtilsTest")
  		true

  		iex> is_test_module?("AutoDoc.Utils")
  		false
  """
  def is_test_module?(module_name) when is_binary(module_name),
    do: String.match?(module_name, ~r/Test\z/)

  @doc """
  	Checks if a module name is a controller test module.

  	## Examples
  		iex> is_controller_test_module?("AutoDocWeb.PageControllerTest")
  		true

  		iex> is_controller_test_module?("AutoDocWeb.PageController")
  		false
  """
  def is_controller_test_module?(module_name) when is_binary(module_name),
    do: String.match?(module_name, ~r/ControllerTest\z/)

  @doc """
  	Checks if a module name is a view test module.

  	## Examples
  		iex> is_view_test_module?("AutoDocWeb.PageViewTest")
  		true

  		iex> is_view_test_module?("AutoDocWeb.PageView")
  		false
  """
  def is_view_test_module?(module_name) when is_binary(module_name),
    do: String.match?(module_name, ~r/ViewTest\z/)

  @doc """
  	Converts a string to PascalCase.

  	## Examples
  		iex> to_pascal_case("helloWorld")
  		"HelloWorld"

  		iex> to_pascal_case("hello_world")
  		"HelloWorld"

  		iex> to_pascal_case("HelloWorld")
  		"HelloWorld"

  		iex> to_pascal_case("Invalid_Type")
  		** (ArgumentError)
  		** ...
  """
  def to_pascal_case(value) when is_binary(value) do
    cond do
      is_pascal_case?(value) ->
        value

      is_camel_case?(value) ->
        length = String.length(value)

        first_letter = value |> String.at(0) |> String.upcase()
        "#{first_letter}#{String.slice(value, 1, length - 1)}"

      is_snake_case?(value) ->
        value
        |> String.split("_")
        |> Enum.map(&String.capitalize/1)
        |> Enum.join()

      true ->
        raise ArgumentError,
              """
              \nERROR
              - Message: Invalid value has been sent. It should be in one of the three main formats (PascalCase, camelCase, snake_case).
              - Value: #{value}
              """
    end
  end

  @doc """
  	Converts a string to camelCase.

  	## Examples
  		iex> to_camel_case("helloWorld")
  		"helloWorld"

  		iex> to_camel_case("hello_world")
  		"helloWorld"

  		iex> to_camel_case("HelloWorld")
  		"helloWorld"

  		iex> to_camel_case("Invalid_Type")
  		** (ArgumentError)
  		** ...
  """
  def to_camel_case(value) when is_binary(value) do
    cond do
      is_pascal_case?(value) ->
        length = String.length(value)

        first_letter = value |> String.at(0) |> String.downcase()
        "#{first_letter}#{String.slice(value, 1, length - 1)}"

      is_camel_case?(value) ->
        value

      is_snake_case?(value) ->
        [head | tail] = String.split(value, "_")

        [head | Enum.map(tail, &String.capitalize(&1))]
        |> Enum.join()

      true ->
        raise ArgumentError,
              """
              \nERROR
              - Message: Invalid value has been sent. It should be in one of the three main formats (PascalCase, camelCase, snake_case).
              - Value: "#{value}"
              """
    end
  end

  @doc """
  	Converts a string to snake_case.

  	## Examples
  		iex> to_snake_case("helloWorld")
  		"hello_world"

  		iex> to_snake_case("hello_world")
  		"hello_world"

  		iex> to_snake_case("HelloWorld")
  		"hello_world"

  		iex> to_snake_case("Invalid_Type")
  		** (ArgumentError)
  		** ...
  """
  def to_snake_case(value) when is_binary(value) do
    cond do
      is_pascal_case?(value) or is_camel_case?(value) ->
        value
        |> String.replace(~r/([^_])([A-Z])/u, "\\1_\\2")
        |> String.downcase()

      is_snake_case?(value) ->
        value

      true ->
        raise ArgumentError,
              """
              \nERROR
              - Message: Invalid value has been sent. It should be in one of the three main formats (PascalCase, camelCase, snake_case).
              - Value: #{value}
              """
    end
  end

  # check if a string is in one of the three main formats (PascalCase, camelCase, snake_case)
  def is_pascal_case?(value) when is_binary(value), do: String.match?(value, @pascal_case_regex)
  def is_camel_case?(value) when is_binary(value), do: String.match?(value, @camel_case_regex)
  def is_snake_case?(value) when is_binary(value), do: String.match?(value, @snake_case_regex)

  # finds the schema path based on given paths and proper nesting logic.
  def find_schema_path(documentation_path, controller_path) do
    main_module_path =
      controller_path
      |> path_to_module_name()
      |> String.split(".")
      |> Enum.at(0)
      |> String.replace_suffix("Web", "")
      |> module_name_to_path()
      |> String.replace_suffix(".ex", "")

    documentation_path
    |> String.replace("/documentation", "")
    |> then(&String.trim_leading(controller_path, &1))
    |> then(&Enum.join([main_module_path, &1]))
    |> String.replace("_controller", "")
    |> String.replace("/controllers/", "/")
  end

  ##########################
  ## 	File Manipulation		##
  ##########################

  @doc """
  Runs `mix format` on given file.

    ## Examples
      iex> run_mix_format("lib/auto_doc/utils.ex")
      {:ok, "File formatted successfully."}

      iex> run_mix_format("lib/auto_doc/utils.ex")
      {:error, "File formatting failed. File: \"lib/auto_doc/utils.ex\""}
  """
  def run_mix_format(file_path) do
    {_output, status} = System.cmd("mix", ["format", "#{@file_path_prefix}#{file_path}"])

    case status do
      0 -> {:ok, "File formatted successfully."}
      _ -> {:error, "File formatting failed. File: \"#{file_path}\""}
    end
  end

  @doc """
  Create nested directories.
  If a directory already exists, it will not raise an error and will continue to the next one in line.
  If the directory does not exist, it will create it and continue to the next one in line.

  Important: The path should contain ONLY directories, not a file at the end or `../` in the beginning.
  """
  def create_nested_directories(path) when is_binary(path) do
    path
    |> Path.dirname()
    |> String.split("/")
    |> Enum.reduce(@file_path_prefix, fn dir, acc ->
      dir_path = "#{acc}#{dir}"
      File.mkdir(dir_path)
      "#{dir_path}/"
    end)
  end

  @doc """
  Read file and returns the content.
  """
  def read_file(path) do
    case File.read("#{@file_path_prefix}#{path}") do
      {:ok, content} -> {:ok, content}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Write to file.
  """
  def write_file(path, content, modes \\ []) do
    case File.write("#{@file_path_prefix}#{path}", content, modes) do
      :ok -> {:ok, "File written successfully."}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Checks if a file exists.

    ## Examples
      iex> file_exists?("lib/auto_doc/utils.ex")
      true

      iex> file_exists?("auto_doc/lib/auto_doc/utils.ex")
      true

      iex> file_exists?("lib/auto_doc/not_existing.ex")
      false
  """
  def file_exists?(file_path) do
    file_path
    |> parse_file_path()
    |> then(&"#{@file_path_prefix}#{&1}")
    |> File.exists?()
  end

  @doc """
  Parses the file path from relative to usable type.
    
    ## Examples
      iex> parse_file_path("lib/auto_doc/utils.ex")
      "auto_doc/lib/auto_doc/utils.ex"

      iex> parse_file_path("auto_doc/lib/auto_doc/utils.ex")
      "auto_doc/lib/auto_doc/utils.ex"
  """
  def parse_file_path(file_path) do
    if String.starts_with?(file_path, "lib/"),
      do: "#{project_container_name()}/#{file_path}",
      else: file_path
  end

  @doc """
  	Guess the possible documentation's `operations.ex` file path.
  """
  def operations_path(documentation_path, controller_path) do
    documentation_path
    |> String.trim_trailing("/documentation")
    |> then(&String.replace_prefix(controller_path, &1, documentation_path))
    |> path_to_module_name()
    |> String.replace_suffix("Controller", ".Operations")
    |> module_name_to_path()
  end

  @doc """
  	Guess the possible documentation's inner-most directory 
    for the `params.ex`, `responses.ex`, `operations.ex` file paths.

    ## Examples
      iex> doc_path("auto_doc/lib/auto_doc/documentation", "lib/auto_doc_web/controllers/page_controller.ex")
      "auto_doc/lib/auto_doc_web/documentation/page"
  """
  def doc_path(documentation_path, controller_path) do
    documentation_path
    |> String.trim_trailing("/documentation")
    |> then(&String.replace_prefix(controller_path, &1, documentation_path))
    |> path_to_module_name()
    |> String.replace_suffix("Controller", ".DummyName")
    |> module_name_to_path()
    |> Path.dirname()
  end

  @doc """
  	Generates the file path for the documentation file.

    ## Examples
      iex> doc_file_path("auto_doc/lib/auto_doc/documentation", "lib/auto_doc_web/controllers/page_controller.ex", "params.ex")
      "auto_doc/lib/auto_doc_web/documentation/page/params.ex"
  """
  def doc_file_path(documentation_path, controller_path, file_name) do
    "#{doc_path(documentation_path, controller_path)}/#{file_name}"
  end
end
