# Auto Doc
Automatic Documentation Generation for OpenApiSpex.

Auto Doc allows you to generate almost complete OpenApiSpex documenation in the span of a couple minutes.
The only requirements are following the standard _**"directory hierarchy"**_ and **_"naming convention"_** in your project.
Note: It works on MacOS but still hasn't been tested on Windows(their backwards path structure will cause an issue)

# Installation
Add the following dependencies to `mix.exs` file `deps/0` function.

Note: We'll need `Jason` and `HTTPoison` to format the data and do the API calls.

```elixir
{:jason, "~> 1.2"},
{:httpoison, "~> 2.0"},
{:auto_doc_package, git: "https://github.com/zen-dev-lab/auto_doc_package"}
```

# Registration
1. Go to [auto-doc.fly.dev](https://auto-doc.fly.dev/)
2. Click _**Sign in**_
3. Register via Github OAuth
4. Being forwarded to your _**dashboard**_ page where a personal user `token` can be seen(important for later)

![Register via Github](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/ef0db07f-c992-4581-ab12-46275b50b26c)

# Personal Github Access Token
For Authorizing API calls to _**Auto Doc**_, you'll need a personal access token.
1. Navigate to `settings/tokens` page [here](https://github.com/settings/tokens?type=beta)
2. Click _**Generate new token**_
3. Give it some name and set your expiration date to 90 days or more
4. Click _**Generate token**_
5. Copy your personal access token (important in for the next step)

![Github access token](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/79f594af-9359-462f-b196-2ed386075cfe)

# Setup ENV Variables
In your `.env` file, add the following ENV Variables:
```env
# The Token shown in your Dashboard
export AUTO_DOC_USER_TOKEN="your-user-token-here"
# The Github Access Token we just created in the previous step
export GITHUB_ACCESS_TOKEN="your-access-token-here"
```

To apply the changes done to the file, run the following command in your IDE terminal:
```shell
source .env
```

That's it! You can now use the package and API. 🙌

# AutoDocPackage usage
* First, start your **Interactive Elixir shell** by running the following command in your IDE's terminal
  ```shell
  iex -S mix
  ```
* Then, we need to pick the documentation directory and the controller to create OpenApiSpex docs for.
* Copy the relative paths to both the _directory_ and _the controller file_ and assign them to variables.
  ```shell
  documentation_path = "example/lib/example_web/documentation"
  controller_path = "example/lib/example_web/controllers/page_controller.ex"
  ```
* Now, execute the function written below
  ```shell
  AutoDocPackage.Requests.gen_example_data_file(documentation_path, controller_path)
  ```
* Notice that under the `lib/` directory a new file with the name `example_data.json` has been created.
* Open it and check its content.
* It contains two types of keys:
  * _special keys_(start and end with `__`) which musn't be edited.
  * _operation keys_(each key corresponds to a new undocumented action in your controller)

### TODO: Insert image here of all the steps mentioned above as well as the file's content

* With the `example_data.json` file present, what's left to do is add the params/response payloads for each action key
and then run the `gen_api_spex/1` commmand with the corresponding argument.
  * There are three possible arguments for that command
    * `:params` or `"params"` -> states that params payloads have been passed and should create the new Params modules 
    * `:response` or `"response"` -> states that response payloads have been passed and should create the new Response modules
    * `:operations` or `"operations"` ->  states that the new Params/Response modules have been created and should add the new operation functions (and their aliases)
  * Generate **response** modules
    * Pass the response payloads as described earlier and run
      ```shell
      AutoDocPackage.Requests.gen_api_spex(:response)
      ```
    * Then, your `response.ex` file will be generated or the new modules will be appended to the existing file.
    * ### TODO: Add image showing the filled payload and the generated module
  * Generate **params** modules:
    * Same as the previous step but you pass the params payloads and run the command with `:params` argument
      ```shell
      AutoDocPackage.Requests.gen_api_spex(:params)
      ``` 
    * **Important!** -> For actions which don't have params payload(such as `GET` requests), then remove the respective keys from the `example_data.json` file to avoid unnecessary Params modules generation.
    * ### TODO: Add image showing the filled payload and the generated module
  * Generate operations module/functions:
    * After completing the previous two steps, simply run
      ```shell
       AutoDocPackage.Requests.gen_api_spex(:operations)
      ```
    * You'll notice that the new operations functions have been added to the end of your `operations.ex` file's `Operations` module and the params/response aliases have also been included.
    * You're done! Your OpenApiSpex Documentation is completed
    * ### TODO: Add image showing the newly generated functions and the added aliases to the top of the Operations module
   
  * Important!
    * Use as detailed payloads as possible since they're the most important part of types/values generation and mapping. 
    * Descriptions are still written manually and for that case, search for the `TOWRITE` keyword and change all occurences with your custom text.
    * If a type wasn't recognized upon generation, it'll have value of `:unknown` and should be changed to the proper value manually.
    * In params payload, if one of the main keys matches the model(schema)'s field name, its `default` and `values` will be mapped and also be added to the API Docs automatically.
    * ### TODO: Add image of the model field mapping to the OpenApiSpex data generation


----
----
# THE OLD and not-so-reader-friendly DOCUMENTATION IS WRITTEN BELOW. FEEL FREE TO SKIP IT.
----
----


# Auto Doc
Automatic Documentation Generation for OpenApiSpex.

Auto Doc allows you to generate almost complete OpenApiSpex documenation in the span of a couple minutes.
The only requirements are following the standard _**"directory hierarchy"**_ and **_"naming convention"_** in your project.
#  
# Installation
We'll need `Jason` and `HTTPoison` to format the data and do the API calls.

```elixir
{:jason, "~> 1.2"},
{:httpoison, "~> 2.0"},
{:auto_doc_package, git: "https://github.com/zen-dev-lab/auto_doc_package"}
```
#  
# Configuration
In your `.env` file, add the following ENV Variables:
```env
AUTO_DOC_USER_TOKEN="your-user-token-here"
GITHUB_ACCESS_TOKEN="your-access-token-here"
```
You can find their values completing [this step](https://github.com/zen-dev-lab/auto_doc_package?tab=readme-ov-file#set-env-variables).

To apply the changes done to the file, run the following command in your IDE terminal:
```shell
source .env
```

That's it! You can now use the package and API. 🙌

Follow the [Quick Guide](https://github.com/zen-dev-lab/auto_doc_package?tab=readme-ov-file#quick-guidestep-by-step-usage) to create your documentation in no time.

There's a more in-depth documentation [below](https://github.com/zen-dev-lab/auto_doc_package?tab=readme-ov-file#how-to-use-in-depth-explanation) 📖
#  
# Quick Guide(step by step usage)
The entire workflow consists of two functions which need to be run in order and your http request/response payloads which will be passed to a specifically generated JSON file under with the name of `example_data.json` located under the `lib/` directory.

The first function to be run is called `gen_example_data_file` and takes two arguments. The first one is the relative path to the documentation directory and the second one is the relative path to the controller you want documentation for.

![image](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/78146b0d-9ad3-42ef-8a7b-abaaa3c86804)

As you can see, upon executing the function, the JSON file we spoke of earlier has been generated. When you open it, you’ll see two types of keys. The first type is called _special keys_ starting and ending with `__`. They shouldn’t be touched if you want everything to work properly.

The second type is operation keys and as you probably already guessed, they have the names of your controller actions which don’t yet have documentation.

![image](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/e3607cb6-1451-4a1c-8537-30202521d67f)

The most optimal approach here is to paste the HTTP Response payloads for each action as values next to their corresponding keys.

![image](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/8e121bee-7958-44b4-8331-effadc3e78a3)

After completing this step, you’ll have to run the second function which will generate your files. It takes one parameter which corresponds to the files we need to generate documentation for.

Since we passed the response payloads, simply run the following: 
```elixir
AutoDocPackage.Requests.gen_api_spex(:response)
```

This should’ve generated the necessary subdirectories and  `responses.ex` file under the chosen `documentation` path.

Great!

Now, let’s do the same for the params and operations.

This time, you have to paste the http request payloads analogically to what we did earlier in the JSON file and delete the keys corresponding to the actions which shouldn’t have params, e.g. the `GET` requests.

Run 
```elixir
AutoDocPackage.Requests.gen_api_spex(:params)
```

Perfect! You now have over 90% your documentation written inside your `params.ex` and `responses.ex`.
What’s left to do now is to generate the `operations.ex` file and here we have a surprise for you.

When running the function generating the file, it’ll add a default error file and specialised `errors.ex` file related to your controller. The default error file is the following: `documentation/errors/not_authenticated.ex`

![image](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/0bdc1164-cc95-4874-9167-b984ed2cb41e)

If the error files already exist, nothing will happen so they’ll not be overwritten.

To generate the `operations.ex` file, just run 
```elixir
AutoDocPackage.Requests.gen_api_spex(:operations)
```

Voila! Your documentation is good to go.

All that’s left is to replace the description for each field with your custom ones.
You can search for the places you need to change something by looking for the keyword `TOWRITE` inside your project.

![image](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/a965bce9-2914-4cf8-acc8-cc386d461a71)

Important:
* Any unrecognized types of data will have value of `:unknown` which should be changed manually.
* Any new action documentation additions to existing `params.ex`, `responses.ex`, `operarions.ex` files will just append the modules/functions to the end of the file. The new functions added to `operations.ex` will automatically include their own modules `alias` so no extra work is required by you.
* Inside the controller module, the new action names are retrieved by matching the `def action_name(conn,` structure, so the first argument should stay as a `conn` variable and not being pattern matched.
* Directories and subdirectories are counted for both path and module name generation, so keep that in mind. For example, if your path is “lib/your_app_web/private/v1/controller/users/user_controller.ex”, then your module name will be `YourAppWeb.Private.V1.Users.UserController`
* Default values inside your schema field’s like `field :name, :string, default: “John”, values: [“John”, “Daisy”, “Peter”]`, if matched inside your http request payload, they’ll be automatically added to the API Documentation.

#  
# How to use (in-depth explanation)
#  
## 1. Registration, Auth, ENV Variables retrieval.
* **registration**
  * Register on our [site](https://auto-doc.fly.dev/) via Github OAuth
* #### Set `.env` variables
  * Go to your [dashboard](https://auto-doc.fly.dev/auth/dashboard) and copy the _**token**_.
    Then add its value to your ENV Variable
    ```env
    AUTO_DOC_USER_TOKEN="your-user-token-here"
    ```
  * Go to [Github Tokens](https://github.com/settings/tokens?type=beta) page and create your Private Access Token
    *  click 'Generate new token'
    *  Give it 'Public Repositories (read-only)' access
    *  Create and copy your _**token**_.
      Then add its value to your ENV Variable
      ```env
      GITHUB_ACCESS_TOKEN="your-access-token-here"
      ```
    * After adding and saving your `.env` variables, run `source .env` in your IDE's terminal
#  
## 2. Commands
There are two functions which will do all the magic. Both are part of the `AutoDocPackage.Requests` module.

You can either use them as-is in the _**Interactive Elixir shell**_(`iex -S mix`) or you can turn them into a `mix` command in your `mix.exs` file.

The first function is called `gen_example_data_file/2` and takes two arguments.
The first argument is the _relative path_ to your desired Documentation directory.
The second argument is the _relative path_ to your desired Controller file.

The second function is called `gen_api_spex/1` and it takes one argument.
The argument refers to your desired action, such as generating _Params/Response module_
to your `params.ex` / `responses.ex` file or adding new operation function to your `operations.ex` file.
#  
### Argument Examples
* For `gen_example_data_file/2`
  * **documentation_path:**
    * `"api/lib/dashboard_api_web/documentation"`
    * `"auto_doc/lib/auto_doc_web/private/v2/documentation"`
    * `"lib/dashboard_api_web/public/v1/documentation"`
    * As you see, the _relative path_ should either start from the `lib/` or the `project_container_name/lib/` directory.
    * Yes, documentation's scope and version are supported.
  * **controller_path:**
    * `"auto_doc/lib/auto_doc_web/controllers/contacts/contact_controller.ex"` 
    * `"lib/dashboard_api_web/private/v2/controllers/contacts/contact_controller.ex"`
    * `"auto_doc/lib/auto_doc_web/public/v1/controllers/contacts/contact_controller.ex"`
    * Needless to say, the structure is the same as the previous argument.
* For `gen_api_spex/1`
  * There's a total of _three_ supported actions and a total of _six_ allowed values:
    * `:params` or `"params"`
    * `:response` or `"response"`
    * `:operations` or `"operations"`
    * _params_ will generate the new Params modules and append them to the respective `params.ex` file
    * _response_ will generate the new Response modules and append them to the respective `responses.ex` file
    * _operations_ will generate the new Operation functions and append them to the end of the respective `operations.ex` file
    * _operations_ command shall be called only after the new _response_ and/or _params_ modules have been generated to avoid errors and inconsistencies. 
#  
### Calling Functions in the Interactive Elixir shell
```shell
~/auto_doc > iex -S mix
iex> documentation_path = "api/lib/dashboard_api_web/documentation"
iex> controller_path = "auto_doc/lib/auto_doc_web/controllers/contacts/contact_controller.ex"
iex> AutoDocPackage.Requests.gen_example_data_file(documentation_path, controller_path)
iex> AutoDocPackage.Requests.gen_api_spex(:params)
iex> AutoDocPackage.Requests.gen_api_spex("response")
iex> AutoDocPackage.Requests.gen_api_spex(:operations)
```
#  
### Creating Mix commands
* Under the `lib/` directory, create a new one called `tasks`
* Under `lib/tasks/` create two files, each of which will correspond to the function we'll call
  * Let's say the first file is called `gen_example_data.ex`. Add the following content inside:
    ```elixir
    defmodule Mix.Tasks.GenExampleData do
      @moduledoc """
      Generate the `example_data.json` file needed for the other tasks.
      """
      use Mix.Task
    
      alias AutoDocPackage.Requests
    
      @impl Mix.Task
      def run([arg1, arg2]), do: Requests.gen_example_data_file(arg1, arg2)
    end
    ```
  * Let's say the second file is called `gen_api_spex.ex`. Add the following content inside:
    ```elixir
    defmodule Mix.Tasks.GenApiSpex do
      @moduledoc """
      Generate the `example_data.json` file needed for the other tasks.
      """
      use Mix.Task
    
      alias AutoDocPackage.Requests
    
      @impl Mix.Task
      def run([arg1]) do
        arg1
        |> String.to_atom()
        |> Requests.gen_api_spex()
      end
    end
    ```
* Go to your `mix.exs` file and inside the `aliases/0` function, add your new commands:
  ```elixir
  defp aliases do
    [
      ...
      "gen.example_data": ["gen_example_data"],
      "gen.api_spex": ["gen_api_spex"]
    ]
  end
  ```
  You can change the `key` names with your custom ones.
* In terminal, use your newly added commands:
  ```shell
  ~/auto_doc > mix gen.example_data "api/lib/dashboard_api_web/documentation" "auto_doc/lib/auto_doc_web/controllers/contacts/contact_controller.ex"
  ~/auto_doc > mix gen.api_spex "params"
  ~/auto_doc > mix gen.api_spex "response"
  ~/auto_doc > mix gen.api_spex "operations"
  ```
#  
## 3. Usage Example
Now that you're familiar with the commands names, arguments and structure in general, let's explain what they do, how they do it.
* Running `AutoDocPackage.Requests.gen_example_path(documentation_path, controller_path)` will generate the `example_path.json` file which has the follwoing structure:
  ```json
  {
    "__controller_path__": "project_name/lib/your_app_web/controllers/module_name_controller.ex",
    "__documentation_path": "project_name/lib/your_app_web/documentation",
    "index": {},
    "show": {},
    "create": {}
  }
  ```
  - Special keys which should always be present(they're automatically added on file generation):
    - "__controller_path__" -> relative path to your controller
    - "__documentation_path__" -> relative path to your documentation's root
  - Keys representing the new API Endpoint operations:  
    - "index"
    - "show"
    - "update"
    - any key that's not a special key (not starting and ending with `__`)

  After the file's been generated, copy the respective JSON payloads corresponding to the operations keys and paste them as their values.
  Next in line is running the `AutoDocPackage.Requests.gen_api_spex(:params)` or `AutoDocPackage.Requests.gen_api_spex(:response)` depending on the payloads set above.
  When the `params.ex` and `responses.ex` files have been generated by the step written on the line above, what's left is to generate the the `operations.ex` file
  by running `AutoDocPackage.Requests.gen_api_spex(:operations)`. Along with the operations file, the `errors.ex` file will also be generated which is used to handle
  the Error responses.

  Note: In your **params** payloads, any **key** matching the related schema(model)'s **field** name, will have their values parsed onto the documentation.
  - Example:
    - example_data.json:
    ```json
    {
      "__controller_path__": "auto_doc/lib/auto_doc_web/controllers/users/user_controller.ex",
      "__documentation_path__": "auto_doc/lib/auto_doc_web/documentation",
      "custom": {}
    }
    ```
    - JSON payload value (this is passed as value of `"custom": ` above):
      ```json
      {
       "data": {
        "bool": true,
        "float": 3.14,
        "int": 29,
        "list": [
         "dog",
         "cat"
        ],
        "map": {
         "key": "value"
        },
        "string": "some-string",
        "uuid": "ed5875d5-9c53-4dea-a546-1bfa03debdfc"
       }
      }
      ``` 
    - parsed in the doc as(OpenApiSpex Schema parsing preview):
    ```elixir
    properties: %{
      data: %Schema{
        description: "TOWRITE: Enter description here.",
        example: %{
          "bool" => true,
          "float" => 3.14,
          "int" => 29,
          "list" => ["dog", "cat"],
          "map" => %{"key" => "value"},
          "string" => "some-string",
          "uuid" => "ed5875d5-9c53-4dea-a546-1bfa03debdfc"
        },
        properties: %{
          bool: %Schema{
            description: "TOWRITE: Enter description here.",
            example: true,
            type: :boolean
          },
          float: %Schema{
            description: "TOWRITE: Enter description here.",
            example: 3.14,
            type: :number
          },
          int: %Schema{
            description: "TOWRITE: Enter description here.",
            example: 29,
            type: :integer
          },
          list: %Schema{
            description: "TOWRITE: Enter description here.",
            example: ["dog", "cat"],
            items: %Schema{
              description: "TOWRITE: Enter description here.",
              example: "dog",
              type: :string
            },
            type: :array
          },
          map: %Schema{
            description: "TOWRITE: Enter description here.",
            example: %{"key" => "value"},
            properties: %{
              key: %Schema{
                description: "TOWRITE: Enter description here.",
                example: "value",
                type: :string
              }
            },
            type: :object
          },
          string: %Schema{
            description: "TOWRITE: Enter description here.",
            example: "some-string",
            type: :string
          },
          uuid: %Schema{
            description: "TOWRITE: Enter description here.",
            example: "ed5875d5-9c53-4dea-a546-1bfa03debdfc",
            format: :uuid,
            type: :string
          }
        },
        type: :object
      }
    }
    ```

  * Running `AutoDocPackage.Requests.gen_api_spex(:params)` will either generate the respective `params.ex` file containing the necessary modules OR it'll append those modules to the end of the `params.ex` file respectively, if it already exist.
     * for this example, `custom` is a `GET` request, so we don't run this command as we don't want to generate params for it.

  * Running `AutoDocPackage.Requests.gen_api_spex(:response)` will either generate the respective `response.ex` file containing the necessary modules OR it'll append those modules to the end of the `response.ex` file respectively, if it already exist.
   * `responses.ex`
   ```elixir
   defmodule AutoDocWeb.Documentation.Users.User.CustomResponse do
    @moduledoc """
    TOWRITE: Enter module description here.
    """
  
    require OpenApiSpex
  
    alias OpenApiSpex.Schema
  
    OpenApiSpex.schema(%{
      example: %{
        "data" => %{
          "bool" => true,
          "float" => 3.14,
          "int" => 29,
          "list" => ["dog", "cat"],
          "map" => %{"key" => "value"},
          "string" => "some-string",
          "uuid" => "ed5875d5-9c53-4dea-a546-1bfa03debdfc"
        }
      },
      properties: %{
        data: %Schema{
          description: "TOWRITE: Enter description here.",
          example: %{
            "bool" => true,
            "float" => 3.14,
            "int" => 29,
            "list" => ["dog", "cat"],
            "map" => %{"key" => "value"},
            "string" => "some-string",
            "uuid" => "ed5875d5-9c53-4dea-a546-1bfa03debdfc"
          },
          properties: %{
            bool: %Schema{
              description: "TOWRITE: Enter description here.",
              example: true,
              type: :boolean
            },
            float: %Schema{
              description: "TOWRITE: Enter description here.",
              example: 3.14,
              type: :number
            },
            int: %Schema{
              description: "TOWRITE: Enter description here.",
              example: 29,
              type: :integer
            },
            list: %Schema{
              description: "TOWRITE: Enter description here.",
              example: ["dog", "cat"],
              items: %Schema{
                description: "TOWRITE: Enter description here.",
                example: "dog",
                type: :string
              },
              type: :array
            },
            map: %Schema{
              description: "TOWRITE: Enter description here.",
              example: %{"key" => "value"},
              properties: %{
                key: %Schema{
                  description: "TOWRITE: Enter description here.",
                  example: "value",
                  type: :string
                }
              },
              type: :object
            },
            string: %Schema{
              description: "TOWRITE: Enter description here.",
              example: "some-string",
              type: :string
            },
            uuid: %Schema{
              description: "TOWRITE: Enter description here.",
              example: "ed5875d5-9c53-4dea-a546-1bfa03debdfc",
              format: :uuid,
              type: :string
            }
          },
          type: :object
        }
      },
      title: "CustomResponse",
      type: :object
    })
   end
   ```

  * Running `AutoDocPackage.Requests.gen_api_spex(:operations)` will either generate the respective `operations.ex` file containing the necessary _operation_ functions OR it'll append those same functions to the end of the Operations module(and include their aliases to the top where they should be) found inside `operations.ex` file respectively, if it already exist.
    * `operations.ex`
      ```elixir
      defmodule AutoDocWeb.Documentation.Users.User.Operations do
        @moduledoc false
      
        import OpenApiSpex.Operation, only: [parameter: 5, request_body: 4, response: 3]
      
        alias AutoDocWeb.Documentation.Errors.NotAuthenticated
        alias AutoDocWeb.Documentation.Users.User.Errors.NotFound
        alias AutoDocWeb.Documentation.Users.User.Errors.UnprocessableEntity
        alias AutoDocWeb.Documentation.Users.User.CustomResponse
        alias AutoDocWeb.Documentation.Users.User.CustomResponse
        alias OpenApiSpex.Operation
        alias OpenApiSpex.Schema
      
        def custom_operation do
          %Operation{
            tags: ["User"],
            summary: "TOWRITE: Enter summary here.",
            operationId: "TOWRITE: Enter operation ID here.",
            description: "TOWRITE: Enter description here.",
            parameters: [
              # TOWRITE: Enter parameters list here
            ],
            security: [%{}, %{"authorization" => []}],
            responses: [
              "200": response("User Custom Response", "application/json", CustomResponse),
              "401": response("Not Authenticated Response", "application/json", NotAuthenticated),
              "404": response("Not Found", "application/json", NotFound),
              "422": response("Unprocessable Entity Response", "application/json", UnprocessableEntity)
            ]
          }
        end
      end
      ```
      * If you don't have `errors.ex` files yet, they'll be automatically generated as well. If they exist, nothing will happen.
     
      ![image](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/b60866eb-bee0-4103-857d-ef4c91cb7f05)

