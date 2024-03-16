# Auto Doc: Effortless OpenApiSpex Documentation
Welcome to Auto Doc, your ultimate solution for generating comprehensive OpenApiSpex documentation in minutes!

With Auto Doc, gone are the days of spending endless hours crafting API documentation. Simply adhere to our standardized directory hierarchy and naming conventions within your project, and let Auto Doc handle the rest.

Key Features:

* Lightning-fast Documentation: Generate almost complete OpenApiSpex documentation in just a couple of minutes.
* MacOS Compatibility: Auto Doc is fully compatible with MacOS. While it hasn't been tested on Windows yet, rest assured, we're working on it!
* Seamless Integration: Easily integrate Auto Doc into your workflow via its intuitive API.
* Subscription-based Service: Enjoy the convenience of a subscription-based microservice,
  offering you a solid foundation for writing professional API Docs while saving you valuable time and resources, all for less than the cost of an hour's work (10€) per month.
* Upgrade your API documentation experience with Auto Doc today and witness unparalleled efficiency and professionalism in your projects.

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
  
  ![copy relative paths](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/d97ad914-26c0-470e-ab7a-5448dfd88cf9)
  
* Now, execute the function written below
  ```shell
  AutoDocPackage.Requests.gen_example_data_file(documentation_path, controller_path)
  ```
* Notice that under the `lib/` directory a new file with the name `example_data.json` has been created.
  ![example_file generated](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/7efdf0e9-05ce-40e4-9cef-095c732d369a)
* Open it and check its content.
  ![example_data filecontent](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/20f522d5-f074-4ae3-9b59-a1093536b2ae)
* It contains two types of keys:
  * _special keys_(start and end with `__`) which musn't be edited.

    ![special keys](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/3fa1f427-3cab-4d6c-a93e-ca6716d5b3aa)
  * _operation keys_(each key corresponds to a new undocumented action in your controller)

    ![operation keys](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/3243948c-e9b4-4b71-a566-96cdfc0bb47a)
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
      ![response payloads in example_data](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/c2744026-6345-46c6-b843-dce275895dd2)

    * Then, your `response.ex` file will be generated or the new modules will be appended to the existing file.
      (Zoom in to check the image in details)
      ![Response modules OpenApiSpex](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/f216e0ae-e159-44fb-80f5-a6c00698997e)

  * Generate **params** modules:
    * Same as the previous step but you pass the params payloads and run the command with `:params` argument
      ```shell
      AutoDocPackage.Requests.gen_api_spex(:params)
      ```
      ![params payload in example_data](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/04890892-96dc-4df0-b4ee-d1a22d63879a)
 
    * **Important!** -> For actions which don't have params payload(such as `GET` requests), then remove the respective keys from the `example_data.json` file to avoid unnecessary Params modules generation.
      This behaviour is shown in the example image(`show` and `index` keys have been removed). 
  * Generate operations module/functions:
    * After completing the previous two steps, simply run
      ```shell
       AutoDocPackage.Requests.gen_api_spex(:operations)
      ```
      ![Operations module](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/5dff9ec5-4dbf-4a91-9037-4e7a00a60edb)

    * You'll notice that the new operations functions have been added to the end of your `operations.ex` file's `Operations` module and the params/response aliases have also been included.
    * Default `errors/` directory will be created in the root of your `documentation/` dir. It'll contain a default error file handling status `401`.

      ![not authenticated error file](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/dfbcb521-6362-4c24-9658-ef5f30ce12ab)

    * If you don't have `errors.ex` file present, a default one will be generated to handle statuses `404` and `422` which are aliased and used in the **Operations** module.
      If the file exists, nothing will happen, meaning that the content will not be overwritten. 

      ![default errors file](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/e838bb68-db70-48ab-84ab-b9fd12896d13)

    * You're done! Your OpenApiSpex Documentation is completed (excluding any missing fields and description writing)
   
  * Important!
    * Use as detailed payloads as possible since they're the most important part of types/values generation and mapping.
      Anything missing in the payload in return will be missing in the generated documentation. 
    * Descriptions are still written manually and for that case, search for the `TOWRITE` keyword and change all occurences with your custom text.
      
      ![towrite example](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/6fbd8227-bbb8-4b53-9455-ed057bf9f42d)

    * If a type wasn't recognized upon generation, it'll have value of `:unknown` and should be changed to the proper value manually.
    
      ![type unknown](https://github.com/zen-dev-lab/auto_doc_package/assets/49829807/c88ff841-3a43-4d02-9d17-ed3c5f92da91)

      
    * In params payload, if one of the main keys matches the model(schema)'s field name, its `default` and `values` will be mapped and also be added to the API Docs automatically.
