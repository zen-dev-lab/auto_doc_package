defmodule AutoDocPackage.Requests do
  @moduledoc """
  The `AutoDocPackage.Requests` module is used for generating the `example_data.json` file
  and the API Docs files based on the data provided by the `example_data.json` file.

  The module is used for the communication between the `AutoDoc` microservice and your Elixir project.

  More information about the `AutoDoc` microservice can be found at:
  - [Auto Doc](https://auto-doc.fly.dev)
  - [Github README](https://github.com/zen-dev-lab/auto_doc_package?tab=readme-ov-file#auto-doc-effortless-openapispex-documentation).
  """

  # ## For Manual Tests via Terminal
  # documentation_path = "auto_doc/lib/auto_doc_web/documentation"
  # controller_path = "lib/auto_doc_web/controllers/page_controller.ex"
  # AutoDocPackage.Requests.gen_example_data_file(documentation_path, controller_path)

  # AutoDocPackage.Requests.gen_api_spex(:params)
  # AutoDocPackage.Requests.gen_api_spex(:response)
  # AutoDocPackage.Requests.gen_api_spex(:operations)

  alias AutoDocPackage.Utils

  @host "https://auto-doc.fly.dev"
  @auth_api_path "/auth/api"

  @doc """
  Generate the `example_data.json` file containing the special keys(`__documentation_path__`, `__controller_path__`)
  and the keys corresponding to the API actions which do not yet have Documentation.

  ## Extra Info:
    - `example_data.json` is located under `/lib` directory of the project.
    - the special keys MUST NOT be changed.
    - the keys corresponding to the API actions are empty upon creation `{}` but
      they should be filled by you(the user) with their respective HTTP Request/Response payload data.
    - The data stored inside the `example_data.json` file is used for generating the API Docs files by the `gen_api_spex` function.

  ## Parameters
    - `documentation_path` - The relative path to the documentation folder.
    - `controller_path` - The relative path to the controller file.

  ## Returns
    - `{:ok, "File formatted successfully."}` - If the file is successfully generated (since it's formatted in the end)
    - `{:error, reason}` - If the file fails to be generated (`reason` here could be format failure or http response body/reason)

  ## Example

    ```elixir
    iex> documentation_path = "auto_doc/lib/auto_doc_web/documentation"
    iex> controller_path = "lib/auto_doc_web/controllers/page_controller.ex"
    iex> AutoDocPackage.Requests.gen_example_data_file(documentation_path, controller_path)
    {:ok, "File formatted successfully."}
    ```
  
  """
  def gen_example_data_file(documentation_path, controller_path) do
    documentation_path = Utils.parse_file_path(documentation_path)
    controller_path = Utils.parse_file_path(controller_path)

    controller_content = get_content(controller_path)

    if is_nil(controller_content) do
      {:error, "Controller file does not exist. Path: #{controller_path}"}
    else
      Utils.create_nested_directories("#{documentation_path}/dummy_file.ex")

      operations_content =
        documentation_path
        |> Utils.operations_path(controller_path)
        |> get_content()

      request_body =
        %{
          "controller_path" => controller_path,
          "documentation_path" => documentation_path,
          "project_container_name" => Utils.project_container_name(),
          "controller_content" => controller_content,
          "operations_content" => operations_content
        }
        |> Jason.encode!()

      url = "#{@host}#{@auth_api_path}/gen_example_data_file"
      httpoison_post(url, request_body)
    end
  end

  @doc """
  Generate the API Docs files based on the data provided by the `example_data.json` file.
  Used for generating the API Docs files for the Params, Response, and Operations. (+ Errors)

  ## Parameters
    - `type` - The type of the API Docs file to be generated. Must be one of [:params, :response, :operations, "params", "response", "operations"].

  ## Returns
    - `{:ok, "File formatted successfully."}` - If the file is successfully generated (since it's formatted in the end)
    - `{:error, reason}` - If the file fails to be generated (`reason` here could be format failure or http response body/reason)

  ## Example

    ```elixir
    iex> AutoDocPackage.Requests.gen_api_spex(:params)
    {:ok, "File formatted successfully."}
    ```
  """
  def gen_api_spex(type)
      when type in [:params, :response, :operations, "params", "response", "operations"] do
    do_gen_api_spex(type)
  end

  def gen_api_spex(_) do
    {:error,
     "Invalid type. Type must be one of [:params, :response, :operations, \"params\", \"response\", \"operations\"]"}
  end

  ####################################
  ## 	GEN_API_SPEX Action Functions	##
  ####################################
  defp do_gen_api_spex(type) do
    example_data_file_path = "#{Utils.project_container_name()}/lib/example_data.json"
    encoded_example_data_file_content = get_content(example_data_file_path)

    if is_nil(encoded_example_data_file_content) do
      {:error, "ERROR: Example Data file does not exist. Path: #{example_data_file_path}"}
    else
      write_modes = if type in [:params, :response, "params", "response"], do: [:append], else: []
      do_gen_api_spex(type, encoded_example_data_file_content, write_modes)
    end
  end

  # Common structure parts of the GEN_API_SPEX function patterns
  defp do_gen_api_spex(type, encoded_example_data_file_content, write_modes) do
    %{
      "__documentation_path__" => documentation_path,
      "__controller_path__" => controller_path
    } = example_data_content = Jason.decode!(encoded_example_data_file_content)

    table_schema_content =
      documentation_path
      |> Utils.find_schema_path(controller_path)
      |> get_content()

    request_body = %{
      "has_base_error_files" =>
        Utils.file_exists?("#{documentation_path}/errors/not_authenticated.ex"),
      "has_error_files" =>
        Utils.file_exists?("#{Utils.doc_path(documentation_path, controller_path)}/errors.ex"),
      "type" => type,
      "example_data_content" => example_data_content,
      "table_schema_content" => table_schema_content,
      "project_container_name" => Utils.project_container_name()
    }

    request_body =
      if type in [:operations, "operations"] do
        operations_specific_params(documentation_path, controller_path) |> Map.merge(request_body)
      else
        request_body
      end
      |> Jason.encode!()

    url = "#{@host}#{@auth_api_path}/gen_api_spex"
    httpoison_post(url, request_body, write_modes)
  end

  # `Request Body` params specific to the Operations HTTP Request.
  defp operations_specific_params(documentation_path, controller_path) do
    %{
      "params_names" =>
        Utils.doc_file_path(documentation_path, controller_path, "params.ex") |> get_names(),
      "responses_names" =>
        Utils.doc_file_path(documentation_path, controller_path, "responses.ex") |> get_names(),
      "controller_content" => get_content(controller_path),
      "operations_content" =>
        Utils.doc_file_path(documentation_path, controller_path, "operations.ex") |> get_content()
    }
  end

  ################################
  ## 	Generic Private Functions	##
  ################################

  # Get the content of a file if it exists. Otherwise, return nil.
  defp get_content(path) do
    if Utils.file_exists?(path) do
      Utils.run_mix_format(path)
      {:ok, content} = Utils.read_file(path)
      content
    else
      nil
    end
  end

  # Get the names of the modules in a file. Specifically designed for the Params/Response files in the documentation folder.
  defp get_names(path) do
    case Utils.read_file(path) do
      {:ok, content} ->
        ~r/defmodule\s+(\S+)\s+do/
        |> Regex.scan(content, capture: [1])
        |> List.flatten()
        |> Enum.map(&Enum.at(String.split(&1, "."), -1))

      _ ->
        []
    end
  end

  defp httpoison_post(url, request_body, write_modes \\ []) do
    headers = http_req_headers()

    case HTTPoison.post(url, request_body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
        %{"type" => _type, "data" => data} = Jason.decode!(body)

        Enum.map(data, fn {k, v} ->
          {file_path, content} = {k, v}

          Utils.create_nested_directories(file_path)
          Utils.write_file(file_path, content, write_modes)
          Utils.run_mix_format(file_path)
        end)

      {:ok, %HTTPoison.Response{status_code: _status_code, body: body}} ->
        {:error, body}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp http_req_headers() do
    content_type_header = {"Content-Type", "application/json"}
    authorization_header = {"Authorization", "Bearer #{System.get_env("GITHUB_ACCESS_TOKEN")}"}
    user_token_header = {"Token", System.get_env("AUTO_DOC_USER_TOKEN")}

    [content_type_header, authorization_header, user_token_header]
  end
end
