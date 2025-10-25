# Domain Resource Action Architecture

The Domain Resource Action is an architecture pattern where each module for the Business Logic layer represents a single action possible on a Resource of a Domain or SubDomain of a Domain. This means that each module for a Resource Action is responsible for only one action, therefore it can only contain one public method, and when necessary it's bang version, the function name ending with `!`, e.g. `read/1` and `read!/1`.

All modules inside a Resource Action can only be accessed through the Resource API module from the web layer (LiveViews, Controllers, etc.), from other Domain Resources or from the same Resource. This reduces accidental complexity by avoiding direct coupling between modules across boundaries. This also makes very easy to refactor later the code because anything consuming the Business Logic is only aware of the API module for the Resource.

Each Resource Action is unit tested and the Resource API it's only tested via its doc-tests to ensure docs examples are in sync with the code and that each function can be invoked.

Any project following this DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md MUST strictly adhere to [1. Folder Structure](#1-folder-structure) and implement [2. Milliseconds Timestamps](#2-milliseconds-timestamps)] and [3. Binary IDs](#3-binary-ids) without making assumptions, in doubt always ask to the user for clarifications.

## 1. Folder Structure 

### 1.1 Mockup Example for an Online Shop

The below folder structure only contains the minimal number of Elixir files required to illustrate the Domain Resource Action pattern:

```text
lib
├── my_app
│   ├── catalogs
│   │   ├── categories
│   │   │   ├── create
│   │   │   ├── delete
│   │   │   ├── edit
│   │   │   ├── list
│   │   │   ├── new
│   │   │   ├── read
│   │   │   ├── update
│   │   │   └── catalog_category_schema.ex
│   │   ├── products
│   │   │   ├── create
│   │   │   ├── delete
│   │   │   ├── edit
│   │   │   ├── export
│   │   │   ├── import
│   │   │   ├── list
│   │   │   ├── new
│   │   │   ├── read
│   │   │   ├── update
│   │   │   │   ├── update_catalog_product_handler.ex
│   │   │   │   ├── update_catalog_product_core.ex
│   │   │   │   └── update_catalog_product_storage.ex
│   │   │   └── catalog_product_schema.ex
│   │   ├── shared_resources
│   │   │   ├── bulk_create
│   │   │   ├── bulk_update
│   │   │   ├── bulk_delete
│   │   │   └── whatever_else
│   │   ├── catalogs_categories_api.ex
│   │   ├── catalogs_products_api.ex
│   │   └── shared_resources_api.ex
│   ├── shared_domains
│   │   ├── bulk_create
│   │   ├── bulk_update
│   │   ├── bulk_delete
│   │   └── whatever_else
│   ├── warehouses
│   │   └── stocks
│   │   │   ├── export
│   │   │   ├── import
│   │   │   └── warehouse_stock_schema.ex
│   │   └── wharehouses_stocks_api.ex
│   └── shared_domains_api.ex
├── my_app_web
...
```

Breaking down the partial folder structure example for an Online Shop:
- Domains: `catalogs`, `warehouses`  
- Resources: `categories`, `products`, `stocks`  
- Shared Folders: `shared_resources`, `shared_domains`
- Actions: `create`, `delete`, `edit`, `export`, `import`, `list`, `new`, `read`, `update`, `bulk_create`, `bulk_update`, `bulk_delete`
- Resource APIs: `catalogs_categories_api.ex`, `catalogs_products_api.ex`, `wharehouses_stocks_api.ex`, `shared_resources_api.ex`, `shared_domains_api.ex`
- Schemas: `catalog_category_schema.ex`, `catalog_product_schema.ex`, `warehouse_stock_schema.ex`

NOTE: Both Domains and Resources may have a shared folder for actions that are shared or for other things that common to them. Shared folders don't have by default a schema, but they MUST have always the API file.

### 1.2 Patterns to Create Files and Directories

#### 1.2.1 Domain Resource API

As per the folder structure:
- Directory: `lib/my_app/<domain_plural>/`
- File: `<domain_plural>_<resource_plural>_api.ex` (e.g., `lib/my_app/catalogs/catalogs_products_api.ex`)
- Module: `MyApp.<DomainPlural>.<DomainPlural><ResourcePlural>API` (e.g., `MyApp.Catalogs.CatalogsProductsAPI`). Catalogs is the Domain, Categories the Resource, and API the Type of module.

#### 1.2.2 Domain Resource Schema

As per the folder structure:
- Directory: `lib/my_app/<domain_plural>/<resource_plural>/`
- File: `<domain_singular>_<resource_singular>_schema.ex` (e.g., `lib/my_app/catalogs/products/catalog_product_schema.ex`)
- Module: `MyApp.<DomainPlural>.<ResourcePlural>.<DomainSingular><ResourceSingular>Schema` (e.g., `MyApp.Catalogs.Products.CatalogProductSchema`). Catalogs is the Domain, Categories the Resource, and Schema the Type of module.

#### 1.2.3 Domain Resource Action

As per the folder structure:
- Directory: `lib/my_app/<domain_plural>/<resource_plural>/<action_singular>/`
- File: `<action_singular>_<domain_singular>_<resource_singular>_<module_type>.ex` (e.g., `lib/my_app/catalogs/products/update/update_catalog_product_handler.ex`)
- Module: `MyApp.<DomainPlural>.<ResourcePlural>.<ActionSingular>.<ActionSingular><DomainSingular><ResourceSingular><ModuleType>` (e.g., `MyApp.Catalogs.Products.Update.UpdateCatalogProductHandler`). Catalogs is the Domain, Categories the Resource, Update the Action, and Handler the Type of module.

## 1.3 Module Types Added by the Domain Resource Action Pattern

The Module Types listed here are only the ones introduced by using the Domain Resource Action architecture pattern, not a list of all that can be found in an Elixir Phoenix project.

#### 1.3.1 Domain Folder

The Domain folder is located at `lib/my_app/<domain_plural>`, e.g. `lib/my_app/catalogs`.

Module types:

- `API` - This files are the only way that Resources can be accessed, inclusive from inside the Resource itself. They define the public contract for each Resource on the Domain folder.

#### 1.3.2 Domain Resource Folder

The Domain Resource folder is located at `lib/my_app/<domain_plural>/<resource_plural>`, e.g. `lib/my_app/catalogs/products`:

Module types:

- `Schema` - This files are the same Ecto schemas generated in a normal Phoenix project but with the `DomainSingular` used as Prefix and `Schema` as suffix, e.g. Module `CatalogProductSchema` and file `catalog_product_schema.ex`. This name convention is more explicit then the one used by default in Phoenix.
- `Contract` - This files are Elixir structs to pass data around, usually used for input data given to module functions. It's optional but strongly recommend that they some type checking library to make resilient, after all they are a contract, like for example the [ElixirScribe.Behaviour.TypedContract](https://github.com/Elixir-Scribe/elixir-scribe/blob/916778e1151963b1f8ca63108fdbadbca6b4e9bd/lib/elixir_scribe/behaviour_typed_contract.ex#L1). Module name looks like `CatalogProductContract` and file name like `catalog_product_contract', but they aren't illustrated in the folder structure example.

#### 1.3.3 Domain Resource Action Folder

Module Types:

- `Handler` - The entry-point for handling the Action on the Domain Resource. It will be responsible to coordinate all the work required to perform the action to keep data handling and transformation, the business logic, separated from the infrastructure logic, the interactions with the external world (databases, pub-sub, queues, filesystem, third-parties, mailers, sms, etc.).
- `Core` - This modules is where the business logic happens without any side effects. It's only allowed pure data transformations, something in something out. This means that this module receives from the `Handler` all the input it requires to perform its work and returns some output. No interactions with the external world are allowed (databases, pub-sub, queues, filesystem, third-parties, mailers, sms, etc.).
- `Storage` - This are the modules where you define the database interactions. No data transformation is allowed here and has in `Core` modules no interactions with the external world are allowed, except with the storage being used (e.g., PostgreSQL, MySQL, MongoDB, Filesystem, etc.). It must receive from the `Handler` all the required attributes (identifiers or data) to execute the storage query to read or save data.
- `PubSub, Queue, Filesystem, ThirdParty, Mailer, SMS` and more - This are the modules where you interact with each specific external systems. This modules cannot interact with `Core` or `Storage`, instead they must receive as input from the `Handler` all they need to perform their work.
    

### 1.4 Modules Examples for the Domain Resource Action Pattern

#### 1.4.1 Domain Resource API 

Example for the file `catalogs_products_api.ex` in the folder structure example.

```elixir
# lib/my_app/catalog/catalogs_products_api.ex
defmodule MyApp.Catalogs.CatalogProductApi do
  @moduledoc """
  The Product API for the Catalogs.
  """
  
  alias MyApp.Catalogs.Products.Update.UpdateCatalogProductHandler
  
  # Not using defdelegate because we will loose the API contract
  @doc """
  Updates a Product in the Catalogs.

  ## Examples

      iex> update_catalog_product(scope, current_product, %{field: new_value})
      {:ok, %CatalogProduct{}}

      iex> update_catalog_product(scope, current_product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_catalog_product(%Scope{} = scope, %CatalogProduct{} = current_product, %{} = attrs) do
    # To make the API contract explicit we may want to use a case statement to check the expected return type.
    UpdateCatalogProductHandler.update(scope, current_product, attrs)
  end
end
```

#### 1.4.2 Domain Resource Action Handler

The Handler main goal is to decouple infrastructure logic from the Busines Core logic.

```elixir
# lib/my_app/catalogs/products/update/update_catalog_product_handler.ex
defmodule MyApp.Catalogs.Products.Update.UpdateCatalogProductHandler do
  @moduledoc false
  
  alias MyApp.Accounts.Scope
  alias MyApp.Catalogs.CatalogProduct
  alias MyApp.Catalogs.CatalogsProductsAPI
  alias MyApp.Catalogs.Products.Update.UpdateCatalogProductCore
  alias MyApp.Catalogs.Products.Update.UpdateCatalogProductStorage

  def update(%Scope{} = scope, %CatalogProduct{} = current_product, %{} = attrs) do
    with {:ok, _scope} <- CatalogsProductsAPI.allowed(scope, :update_catalog_product),
         {:ok, %{} = attrs} <- UpdateCatalogProductCore.execute(current_product, attrs), # <-- USE WHEN MAKES SENSE
         {:ok, catalogs_product = %CatalogProduct{}} <- UpdateCatalogProductStorage.update(catalogs_product, attrs) do
           
      # Ideally we want to broadcast the product update and let other parts of the system react to it:
      #  - to notify users by sms or email.
      #  - for analytics
      #  - business intelligence
      #  - Etc.
      CatalogsProductsAPI.broadcast_catalogs_product(scope, {:catalog_product_updated, catalogs_product}) # <-- STRONGLY RECOMMENDED
      
      # An alternative is to trigger the reactions to this update with cross boundary calls via the Domain Resource API.
      # Using a cross boundary call to the Domain Resource API avoids direct coupling to the internal of the Domain.
      # This is soft couplig, which reduces accidental coupling and complexity.
      MailerNotifierAPI.notify_users(scope, {:catalog_product_updated, catalogs_product}) # <-- MIDDLE GROUNG RECOMMENDATION
      
      # Bear in mind that by doing this approach of direct cross boundary calls we are coupling this module with anything we interact with.
      # This is often called accidental complexity via accidental coupling. 
      # This may seem innocent when the project is small, but will bite us back when it grows.
      UsersMailerNotifier.notify_users(scope, {:catalog_product_updated, catalogs_product}) # <-- NOT RECOMMENDED
      
      {:ok, catalogs_product}
    end
  end
end
```

Core modules inside a Resource Action folders aren't limited to one, like pictured in folder structure example by `update_catalog_product_core.ex`. This means we can have more than one Core module for whatever we need to do in therms of:
- business rules validation
- data transformation
- data enrichment
- anything else that as no side effects or communicates with the external world.

For example, the width clause on the above example would have some more calls to core modules:

```elixir
with {:ok, _scope} <- CatalogsProductsAPI.allowed(scope, :update_catalog_product),
     {:ok, %{} = attrs} <- BusinessRulesUpdateCatalogProductCore.enforce(business_rules, current_product, attrs), # <-- USE WHEN MAKES SENSE
     {:ok, %{} = attrs} <- TransformUpdateCatalogProductCore.transform(current_product, attrs), # <-- USE WHEN MAKES SENSE
     {:ok, %{} = attrs} <- EnrichUpdateCatalogProductCore.enrich(current_product, attrs), # <-- USE WHEN MAKES SENSE
     {:ok, %{} = attrs} <- UpdateCatalogProductCore.execute(current_product, attrs), # <-- USE WHEN MAKES SENSE and use a proper function name
     {:ok, catalogs_product = %CatalogProduct{}} <- UpdateCatalogProductStorage.update(catalogs_product, attrs) do
  ...
end
```

This split in several Core modules is useful in complex Business Domains, that have complex rules and data transformations/enrichments and whatever else. When the Business Domain is straightforward and simple, then we want to only use one single Core module, probably to validate the Business Rules. It's also ok to not even use a Core module if it doesn't make sense for the current Resource Action being handled.

#### 1.4.3 Domain Resource Action Core Module Example

The main goal of a Core module is to process Business Logic in a deterministic way and without side effects.

```elixir
# lib/my_app/catalogs/products/update/update_catalog_product_core.ex
defmodule MyApp.Catalogs.Products.Update.UpdateCatalogProductCore do
  @moduledoc false
  
  # This must be a pure function. No side effects allowed.
  def execute(%CatalogProduct{} = current_product, %{} = attrs)) do
    # Your Business Logic goes here
    attrs
  end

end
```

#### 1.4.4 Domain Resource Action Storage Module Example

The main goal of the storage module is to decouple database access from the business logic.

```elixir
# lib/my_app/catalogs/products/update/update_catalog_product_core.ex
defmodule MyApp.Catalogs.Products.Update.UpdateCatalogProductStorage do
  @moduledoc false
  alias MyApp.Repo
  alias MyApp.Accounts.Scope
  alias MyApp.Catalogs.CatalogProduct
  alias MyApp.Catalogs.CatalogsProductsAPI

  def update(%Scope{} = scope, %CatalogProduct{} = current_product, attrs) do
    current_product
    |> CatalogsProductsAPI.edit(attrs, scope) # <-- calling the changeset via the API
    |> Repo.update()
  end

end
```

### 1.5 Web Layer

#### 1.5.1 Using Domain Resources Architecture on the Web Layer

The web layer (my_app_web in the example) is kept as its generated by Phoenix code generators with the `--web` option flag to set the domain for each resource. This brings the web layer as close as possible from the architecture used in the Business Logic layer.

Usually the mix code generators follow this format:  `mix <phx.gen.* <DomainPlural>.<ResourcePlural> <ResourceSingular> <resource_plural> ... --web <DomainPlural>.<ResourcePlural>`. See how the `--web Accounts.Users` matches exactly the Context module `Accounts.Users` namespace given as the first argument to the command. This is **MANDATORY** when creating commands to generate code for this architecture on the web layer.

Some examples:
  - `mix phx.gen.auth Accounts.Users User users --live --web Accounts.Users` 
  - `mix phx.gen.live Catalogs.Products Product products name:string desc:string --web Catalogs.Products`

The removed files should have already been created or need to be created by following **1.2 Patterns to Create Files and Directories**.

#### 1.5.2.1 Removing Generated Files in the Business Logic Layer

**CRITICAL:** This step **MUST NOT** be applied to the `mix phx.gen.auth` generator.

Unfortunately the phoenix generators don't have a flag to not generate code in the business layer, the current flags `--no-context` an `--no-schema` still generate the files with placeholders, therefore we need to remove both the context and schema files after running the code generator.

For example, for the command `mix phx.gen.live Catalogs.Products Product products name:string desc:string --web Catalogs.Products` we **MUST** remove:

* `lib/my_app/catalogs/products.ex`
* `lib/my_app/catalogs/products/product.ex`

#### 1.5.2 Routes with Domain and Resource

Every-time a code generator is used, that supports the option `--web`, it must be used in the format `-web <DomainPlural>.<ResourcePlural>`, e.g. `--web Accounts.Users`. 

Unfortunately a small bug exists in the code generators and the routes will have the resource `users` duplicated, e.g. `http://example.com/accounts/users/users/register`, but instead it needs to be `http://example.com/accounts/users/register`. 

To fix this the `router.ex` needs to be edited to remove the duplication by finding each use of `live "/users/...` and make it look like `live "/..."`, e.g., from `live "/users/register"` to `live "/register"`. Afterwards we run `mix compile` and fix all warnings about the routes mismatch, e.g., `~p/accounts/users/users/register` to `~p/accounts/users/register`. The fix must be done on a single pass across all files, instead of doing one file at a time, by compiling the list of routes that need to be fixed on all files from the warnings of running `mix compile`.

#### 1.5.3 Accessing the Business Logic Layer from the Web Layer

Calls from the web layer, like from a live view or controller are only allowed to a Domain Resource API, that in the folder structure example would be to one of the modules defined at `catalogs_categories_api.ex`, `catalogs_products_api.ex` and `wharehouse_stocks_api.ex`. This means that the usual calls to the context need to be replaced with calls to the Domain Resource API. For example, replacing `Catalogs.update_product` with `CatalogsProductsAPI.update_product`.

Both a live view and a controller must only have logic to deal with web layer concerns, which usually consists in calling a Domain Resource API with the parameters of the request mapped to existing atoms, and deal with the returned result to decide if the web layers succeeds or fails the response it needs to send back.


##### 1.5.3.1 Atomized Attributes

The use of atomized attributes its not required to be introduced to existing code, but its recommend that at some point to refactor the existing code to use them, if not already done.

When this Architecture pattern is analyzed for the first time by an AI Coding Agent its recommended for it to check if the project is already using atomized parameters to call the Business Logic layer, and if not then ask the developer if he wants to use @PLANNING.md to create an Intent with the tasks to implement it, or if he wants to do it himself. The Intent **MUST** be created as specified by the @INTENT_SPECIFICATION.md and exemplified by the @INTENT_EXAMPLE.md.


##### 1.5.3.2 Example of calling the a Domain Resource API from LiveView

LiveVew mode trimmed to show only the code for the `edit` handle event, that's enough to illustrate the call to the Domain Resour API with atomized attributes:


```elixir
# lib/my_app_web/live/catalogs/products/product_live/form.ex
defmodule MyAppWeb.Catalogs.Products.ProductLive.Form do
  
  ...
  
  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.live_action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    # Atomize the product_params to only pass the ones you are interested in.
    # Prevents passing extra parameters from requests sent by attackers. We may 
    # also want to sanitize the values.
    # This line of code isn't generated by any mix phx.gen.*
    product_attrs = MyApp.atomize_params_map(["name"])

    # The use of the above call to `atomize_params_map/1` is optional, provided 
    # the project uses another approach to atomize the attributes into a regular 
    # map or struct. For example, one that atomizes and sanitizes the parameters 
    # into a struct specific to each action or resource:
    # `product_attrs = %CatalogProductInputSanitezed{} = MyAppWeb.Catalogs.Products.sanitize_product_params(product_params)` 
    
    case CatalogsProductsAPI.update_product(socket.assigns.current_scope, socket.assigns.product, product_attrs) do
      {:ok, product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, product)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
  
  ...
end
```

##### 1.5.3.3 Example to atomize attributes

The below function `atomize_params_map/2` is only a simple example how to 
achieve this, but the project may already have another approach to do it. 

```elixir

# lib/my_app.ex
defmodule MyApp do
  # This code isn't generated by any mix phx.gen.*
  # It needs to be added by us for by the AI code assistant in case we want to 
  # use this approach.
  # We are free to use anything else, provided that it results in atomized 
  # attributes in a regular map or in a struct.
  def atomize_params_map(%{} = params, keys_to_take, keys_to_atomize_values \\ [])
      when is_list(keys_to_take) and is_list(keys_to_atomize_values) do
    params
    |> Map.take(keys_to_take)
    |> Enum.into(%{}, fn {key, value} ->
      atom_key = String.to_existing_atom(key)

      value =
        if key in keys_to_atomize_values and is_binary(value),
          do: String.to_existing_atom(value),
          else: value

      {atom_key, value}
    end)
  end
end
```

##### 1.5.3.4 Example to atomize and sanitize attributes

A better approach would be to use a dedicated struct for each Domain Resource accept input from the external world that atomizes the request input parameters into existing atoms and sanitizes their values.

```elixir
defmodule MyAppWeb.Catalogs.Products.CatalogProductInputSanitezed do
  
  # Define here the struct. 
  # THe struct **MUST** explicitly enforce the required attributes.

  def sanitize_product_params(input_params) do
    # For each atom key in the struct we want to sanitize the input_params value
    # present in the correspondent string key.

    # You may want to just let it crash if the required keys aren't all present.
    
    # Return the struct. 
  end
end

```

## 2. Milliseconds Timestamps 

By default Phoenix generates schemas and migration with timestamps in `:utc_datetime` which have a default precision of seconds, thus making impossible to order records in database queries by the insert or update times, because several records can be inserted or updated in the same second.

The solution is to modify in `config/config.exs`, the `generators` configuration to use `timestamp_type: :utc_datetime_usec` and the code generators will use them by default when creating migrations and schemas.

If migrations or schemas are being created without the use of the code generator they also must use the `:utc_datetime_usec` timestamp.

When this Architecture pattern is analyzed for the first time by an AI Coding Agent it **MUST** check `config/config.exs` to see if the project is already using binary IDs and if not then ask the developer if he wants to use @PLANNING.md to create an Intent with the tasks to implement it, or if he wants to do it himself. The Intent **MUST** be created as specified by the @INTENT_SPECIFICATION.md and exemplified by the @INTENT_EXAMPLE.md.


## 3. Binary IDs

For security reasons this architecture requires that all migrations and schemas use binary IDs for the primary key and foreign keys. 

UUIDV7 as binary IDS are strongly recommended because they can be sorted in database queries, once they are time based.

When this Architecture pattern is analyzed for the first by an AI Coding Agent it **MUST** check `config/config.exs` to see if the project is already using binary IDs and if not then ask the developer if he wants to use @PLANNING.md to create an Intent with the tasks to implement it, or if he wants to do it himself. The Intent **MUST** be created as specified by the @INTENT_SPECIFICATION.md and exemplified by the @INTENT_EXAMPLE.md.


To add support for UUIDV7 we need to follow this steps:

1. add to `mix.exs` the dependency `{:uuidv7, "~> 0.1"}` and run `mix deps.get`.
2. modify in `config/config.exs`, the `generators` configuration to use `binary_id: {:id, UUIDv7, autogenerate: true}`.
3. modify the default schema template used by the code generator `phx.gen.schema` and `phx.gen.auth` to use `@primary_key {:id, UUIDv7, autogenerate: true}` instead of the default `@primary_key {:id, :binary_id, autogenerate: true}`:
  - `cp deps/phoenix/priv/templates/phx.gen.schema/schema.ex priv/templates/phx.gen.schema/schema.ex`.
  - modify `priv/templates/phx.gen.schema/schema.ex` line with `@primary_key {:id, :binary_id, autogenerate: true}` to `@primary_key {:id, UUIDv7, autogenerate: true}`.
  - `cp deps/phoenix/priv/templates/phx.gen.auth/schema.ex priv/templates/phx.gen.auth/schema.ex`.
  - modify `priv/templates/phx.gen.auth/schema.ex` line with `@primary_key {:id, :binary_id, autogenerate: true}` to `@primary_key {:id, UUIDv7, autogenerate: true}`.
4. in any shema generated without the code generators always ensure that it uses `@primary_key {:id, UUIDv7, autogenerate: true}` instead of the default `@primary_key {:id, :binary_id, autogenerate: true}`.


The above steps can be easily translated to tasks and sub-task when creating an Intent during the planning phase, that **MUST** be created as specified by the @INTENT_SPECIFICATION.md and exemplified by the @INTENT_EXAMPLE.md.
