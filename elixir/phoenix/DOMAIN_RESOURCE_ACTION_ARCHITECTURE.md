# Domain Resource Action Architecture

The Domain Resource Action is an architecture pattern where each module for the Business Logic layer represents a single action possible on a Resource of a Domain or SubDomain of a Domain. This means that each module for a Resource Action is responsible for only one action, therefore it can only contain one public function, and when necessary its bang version, the function name ending with `!`, e.g. `read/1` and `read!/1`.

All modules inside a Resource Action can only be accessed through the Resource API module from the web layer (LiveViews, Controllers, etc.), from other Domain Resources or from the same Resource. This reduces accidental complexity by avoiding direct coupling between modules across boundaries. This also makes it very easy to refactor the code later because anything consuming the Business Logic is only aware of the API module for the Resource.

Each Resource Action is unit tested and the Resource API is only tested via its doctests to ensure docs examples are in sync with the code and that each function can be invoked.

Any project following this DOMAIN_RESOURCE_ACTION_ARCHITECTURE.md MUST strictly adhere to [1. Folder Structure](#1-folder-structure) and implement [2. Milliseconds Timestamps](#2-milliseconds-timestamps) and [3. Binary IDs](#3-binary-ids) without making assumptions, when in doubt always ask the user for clarification.

## 1. Folder Structure 

### 1.1 Mock-up Example for an Online Shop

The below folder structure only contains the minimal number of Elixir files required to illustrate the Domain Resource Action pattern:

```text
lib
├── my_app
│   ├── catalogs
│   │   ├── categories
│   │   │   ├── subscribe
│   │   │   │   └── subscribe_catalog_category.ex
│   │   │   ├── broadcast
│   │   │   │   └── broadcast_catalog_category.ex
│   │   │   ├── list
│   │   │   │   └── list_catalog_categories.ex
│   │   │   ├── get
│   │   │   │   └── get_catalog_category.ex
│   │   │   ├── create
│   │   │   │   └── create_catalog_category.ex
│   │   │   ├── update
│   │   │   │   └── update_catalog_category.ex
│   │   │   ├── delete
│   │   │   │   └── read_catalog_category.ex
│   │   │   ├── change
│   │   │   │   └── change_catalog_category.ex
│   │   │   └── category.ex
│   │   ├── products
│   │   │   ├── subscribe
│   │   │   │   └── subscribe_catalog_product.ex
│   │   │   ├── broadcast
│   │   │   │   └── broadcast_catalog_product.ex
│   │   │   ├── list
│   │   │   │   └── list_catalog_categories.ex
│   │   │   ├── get
│   │   │   │   └── get_catalog_product.ex
│   │   │   ├── create
│   │   │   │   └── create_catalog_product.ex
│   │   │   ├── update
│   │   │   │   └── update_catalog_product.ex
│   │   │   ├── delete
│   │   │   │   └── read_catalog_product.ex
│   │   │   ├── change
│   │   │   │   └── change_catalog_product.ex
│   │   │   └── product.ex
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
│   │   ├── stocks
│   │   │   ├── subscribe
│   │   │   │   └── subscribe_warehouse_stock.ex
│   │   │   ├── broadcast
│   │   │   │   └── broadcast_warehouse_stock.ex
│   │   │   ├── list
│   │   │   │   └── list_warehouses_stocks.ex
│   │   │   ├── get
│   │   │   │   └── get_warehouse_stock.ex
│   │   │   ├── create
│   │   │   │   └── create_warehouse_stock.ex
│   │   │   ├── update
│   │   │   │   └── update_warehouse_stock.ex
│   │   │   ├── delete
│   │   │   │   └── read_warehouse_stock.ex
│   │   │   ├── change
│   │   │   │   └── change_warehouse_stock.ex
│   │   │   └── stock.ex
│   │   └── warehouses_stocks_api.ex
│   └── shared_domains_api.ex
├── my_app_web
│   ├── live
│   │   ├── catalogs
│   │   │   ├── categories
│   │   │   │   ├── category_live
│   │   │   │   │   ├── form.ex
│   │   │   │   │   ├── index.ex
│   │   │   │   │   └── show.ex
│   │   │   ├── products
│   │   │   │   ├── product_live
│   │   │   │   │   ├── form.ex
│   │   │   │   │   ├── index.ex
│   │   │   │   │   └── show.ex
│   │   ├── warehouse
│   │   │   ├── stocks
│   │   │   │   ├── stock_live
│   │   │   │   │   ├── form.ex
│   │   │   │   │   ├── index.ex
│   │   │   │   │   └── show.ex
...
```

Breaking down the partial folder structure example for an Online Shop:
- Domains: `catalogs`, `warehouses`  
- Resources: `categories`, `products`, `stocks`  
- Shared Folders: `shared_resources`, `shared_domains`
- Actions: `subscribe`, `broadcast`, `list`, `get`, `create`, `update`, `delete`, `change`, `bulk_create`, `bulk_update`, `bulk_delete`
- Resource APIs: `catalogs_categories_api.ex`, `catalogs_products_api.ex`, `warehouses_stocks_api.ex`, `shared_resources_api.ex`, `shared_domains_api.ex`
- Ecto Schemas: `category.ex`, `product.ex`, `stock.ex`

NOTE: Both Domains and Resources may have a shared folder for actions that are shared or for other things that are common to them. Shared folders don't have a schema by default, but they **MUST** always have the API module.

### 1.2 Patterns to Create Files and Directories

#### 1.2.1 Domain Resource API

As per the folder structure:
- Directory: `lib/my_app/<domain_plural>/`
- File: `<domain_plural>_<resource_plural>_api.ex` (e.g., `lib/my_app/catalogs/catalogs_products_api.ex`)
- Module: `MyApp.<DomainPlural>.<DomainPlural><ResourcePlural>API` (e.g., `MyApp.Catalogs.CatalogsProductsAPI`). Catalogs is the Domain, Products the Resource, and API the Type of module.

#### 1.2.2 Domain Resource Schema

As per the folder structure:
- Directory: `lib/my_app/<domain_plural>/<resource_plural>/`
- File: `<resource_singular>.ex` (e.g., `lib/my_app/catalogs/products/product.ex`)
- Module: `MyApp.<DomainPlural>.<ResourcePlural>.<ResourceSingular>` (e.g., `MyApp.Catalogs.Products.Product`).

#### 1.2.3 Domain Resource Action

As per the folder structure:
- Directory: `lib/my_app/<domain_plural>/<resource_plural>/<action_singular>/`
- File: `<action_singular>_<domain_singular>_<resource_singular>.ex` (e.g., `lib/my_app/catalogs/products/update/update_catalog_product.ex`)
- Module: `MyApp.<DomainPlural>.<ResourcePlural>.<ActionSingular>.<ActionSingular><DomainSingular><ResourceSingular>` (e.g., `MyApp.Catalogs.Products.Update.UpdateCatalogProduct`).

## 1.3 Module Types Added by the Domain Resource Action Pattern

The Module Types listed here are only the ones introduced by using the Domain Resource Action architecture pattern, not a list of all that can be found in an Elixir Phoenix project.

#### 1.3.1 Domain Folder

The Domain folder is located at `lib/my_app/<domain_plural>`, e.g. `lib/my_app/catalogs`.

Module types:

- `API` - These files are the only way that Resources can be accessed, including from inside the Resource itself. They define the public contract for each Resource on the Domain folder.

#### 1.3.2 Domain Resource Folder

The Domain Resource folder is located at `lib/my_app/<domain_plural>/<resource_plural>`, e.g. `lib/my_app/catalogs/products`:

Module types:

- `Ecto Schema` - These are the usual Ecto Schema module generated by the Phoenix code generators, e.g, `product.ex`.


#### 1.3.3 Domain Resource Action Folder

The Domain Resource Action folder is located at

Module Types:

- For simple actions, like the ones generated by Phoenix code generators, a single module will suffice. For example: `update_category_product.ex`.
- For complex actions it may be wise to separate them into at least three modules:
  - `Handler` - entrypoint module to coordinate the work being done.
  - `Core` - for pure business logic without side effects.
  - `Storage`, `Queues`, etc. - a dedicated module per type of communication with the external world.
    

### 1.4 Modules Examples for the Domain Resource Action Pattern

#### 1.4.1 Domain Resource API 

Example for the file `catalogs_products_api.ex` in the folder structure example.

```elixir
# lib/my_app/catalogs/catalogs_products_api.ex
defmodule MyApp.Catalogs.CatalogProductApi do
  @moduledoc """
  The Product API for the Catalogs.
  """
  
  alias MyApp.Catalogs.Products.Update.UpdateCatalogProduct
  
  # Not using defdelegate because we will lose the API contract
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
    UpdateCatalogProduct.update(scope, current_product, attrs)
  end
end
```

#### 1.4.3 Domain Resource Simple Action 

For simple actions, like the ones generated by Phoenix code generators, a single module will suffice. For example: `update_category_product.ex`:


```elixir
# lib/my_app/catalogs/products/update/update_catalog_product.ex
defmodule MyApp.Catalogs.Products.Update.UpdateCatalogProduct do
  @moduledoc false
  
  alias MyApp.Accounts.Scope
  alias MyApp.Catalogs.Product
  alias MyApp.Catalogs.CatalogsProductsAPI

  def update_product(%Scope{} = scope, %Product{} = product, %{} = attrs) do
    true = product.user_id == scope.user.id

    with {:ok, product = %Product{}} <-
           product
           |> Product.changeset(attrs, scope)
           |> Repo.update() do
      CatalogsProductsAPI.broadcast_product(scope, {:updated, product})
      {:ok, product}
    end
  end

```

#### 1.4.4 Domain Resource Complex Actions

For complex actions it may be wise to separate in at least into three modules:
  - `Handler` - entrypoint module to coordinate the work being done.
  - `Core` - for pure business logic without side effects.
  - `Storage`, `Queues`, etc. - a dedicated module per type of communication with the external world.

##### 1.4.4.1 Domain Resource Action Handler Module Example

The main goal of the Handler is to decouple infrastructure logic from the Business Core logic.

```elixir
# lib/my_app/catalogs/products/update/update_catalog_product_handler.ex
defmodule MyApp.Catalogs.Products.Update.UpdateCatalogProductHandler do
  @moduledoc false
  
  alias MyApp.Accounts.Scope
  alias MyApp.Catalogs.CatalogProduct
  alias MyApp.Catalogs.CatalogsProductsAPI
  alias MyApp.Catalogs.Products.Update.UpdateCatalogProductStorage
  alias MyApp.Catalogs.Products.Update.UpdateCatalogProductBusinessRulesCore

  def update(%Scope{} = scope, %CatalogProduct{} = current_product, %{} = attrs) do
    with {:ok, _scope} <- CatalogsProductsAPI.allowed(scope, :update_catalog_product),
         {:ok, %{} = attrs} <- UpdateCatalogProductBusinessRulesCore.enforce(scope, current_product, attrs), # <-- USE WHEN MAKES SENSE
         {:ok, catalogs_product = %CatalogProduct{}} <- UpdateCatalogProductStorage.update(catalogs_product, attrs) do
           
      # Ideally we want to broadcast the product update and let other parts of the system react to it:
      #  - to notify users by sms or email.
      #  - for analytics
      #  - business intelligence
      #  - etc.
      CatalogsProductsAPI.broadcast_catalogs_product(scope, {:catalog_product_updated, catalogs_product}) # <-- STRONGLY RECOMMENDED
      
      # An alternative is to trigger the reactions to this update with cross boundary calls via the Domain Resource API.
      # Using a cross boundary call to the Domain Resource API avoids direct coupling to the internal of the Domain.
      # This is soft coupling, which reduces accidental coupling and complexity.
      MailerNotifierAPI.notify_users(scope, {:catalog_product_updated, catalogs_product}) # <-- MIDDLE GROUND RECOMMENDATION
      
      # Bear in mind that by doing this approach of direct cross boundary calls we are coupling this module with anything we interact with.
      # This is often called accidental complexity via accidental coupling. 
      # This may seem innocent when the project is small, but will bite us back when it grows.
      UsersMailerNotifier.notify_users(scope, {:catalog_product_updated, catalogs_product}) # <-- NOT RECOMMENDED
      
      {:ok, catalogs_product}
    end
  end
end
```

Calls to core modules from a Domain Resource Action Handler aren't limited to one. This means we can have more than one Core module per action for whatever we need to do in terms of:
- business rules validation
- data transformation
- data enrichment
- anything else that has no side effects or communicates with the external world.

For example, the with clause on the above example would have some more calls to core modules:

```elixir
with {:ok, _scope} <- CatalogsProductsAPI.allowed(scope, :update_catalog_product),
     {:ok, %{} = attrs} <- UpdateCatalogProductBusinessRulesCore.enforce(scope, current_product, attrs), # <-- USE WHEN MAKES SENSE
     {:ok, %{} = attrs} <- UpdateCatalogProductTransformCore.transform(current_product, attrs), # <-- USE WHEN MAKES SENSE
     {:ok, %{} = attrs} <- UpdateCatalogProductEnrichCore.enrich(current_product, attrs), # <-- USE WHEN MAKES SENSE
     {:ok, catalogs_product = %CatalogProduct{}} <- UpdateCatalogProductStorage.update(catalogs_product, attrs) do
  ...
end
```

This split in several Core modules is useful in complex Business Domains, that have complex rules and data transformations/enrichments and whatever else. When the Business Domain is straightforward and simple, then we may not even use a Core module if it doesn't make sense for the current Resource Action being handled.

##### 1.4.4.2 Domain Resource Action Core Module Example

The main goal of a Core module is to process Business Logic in a deterministic way and without side effects.

```elixir
# lib/my_app/catalogs/products/update/update_catalog_product_core.ex
defmodule MyApp.Catalogs.Products.Update.UpdateCatalogProductCore do
  @moduledoc false
  
  # This must be a pure function. No side effects allowed.
  def execute(%Scope{} = scope, %CatalogProduct{} = current_product, %{} = attrs,) do
    # Your Business Logic goes here
    attrs
  end

end
```

#### 1.4.4.3 Domain Resource Action Storage Module Example

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

### 1.5 Domain Resource Action with Phoenix Code Generators

By using Phoenix code generators with the format `<DomainPlural>.<ResourcePlural>` to set the domain and resource in the first argument and in the `--web` option, it will generate code in the web layer (`lib/my_app_web`) and Business Logic layer (`lib/my_app`) in a folder structure that is as close as possible of each other, but both layers will require some refactor to comply with the Domain Resource Action architecture pattern.

#### 1.5.1 Using Phoenix Code Generators Examples

The most commonly used Phoenix code generators may be `mix phx.gen.live` and `mix phx.gen.auth`, for which we have these examples:
  - `mix phx.gen.live Catalogs.Products Product products name:string desc:string --web Catalogs.Products`
  - `mix phx.gen.auth Accounts.Users User users --live --web Accounts.Users` 

See how the `--web Catalogs.Products` matches exactly the Context module `Catalogs.Products` namespace given as the first argument to the command. 

This approach to create the Phoenix commands is **MANDATORY** to generate code for the Domain Resource Action architecture pattern.

#### 1.5.2 Fixing Routes with Domain and Resource

Every time a code generator is used, that supports the option `--web`, it must be used in the format `-web <DomainPlural>.<ResourcePlural>`, e.g. `--web Accounts.Users`. 

Unfortunately a small bug exists in the code generators and the routes will have the resource `users` duplicated, e.g. `http://example.com/accounts/users/users/register`, but instead it needs to be `http://example.com/accounts/users/register`. 

To fix this the `router.ex` needs to be edited to remove the duplication by finding each use of `live "/users/...` and make it look like `live "/..."`, e.g., from `live "/users/register"` to `live "/register"`. 

Afterwards we run `mix compile` and fix all warnings about the routes mismatch, e.g., `~p/accounts/users/users/register` to `~p/accounts/users/register`, by following these steps:

1. You **MUST** run `mix compile` to find all module files with routes to be fixed. 
2. You **MUST** then create a list of files from the the output of `mix compile` that have routes to be fixed.
3. You **MUST** feed the list of files to a **find and replace tool** (e.g. `find` in Linux), to fix all routes in only one pass. You **MUST NOT** try to fix one module at a time, because that will be an exhaustive and time consuming task. 

**IMPORTANT:** See the Authentication document for guidelines on point 3. to understand how to add routes that require authentication. 

#### 1.5.3 Refactoring the Phoenix Context to the Domain Resource Action Architecture

The Phoenix code generators create a kitchen-sink context module to group all resource actions for a domain in one single module.

While Phoenix contexts look neat and simple, this only holds true at the begin of a project with CRUD actions, but without any business logic applied to them.

As an application grows with more resources and business logic needs to be added to deal with business requirements, then they gradually become hard to reason about, therefore more difficult to maintain and add new features, fix bugs, and to refactor.

##### 1.5.3.1 How to Refactor the Phoenix Context Example

Let's use as an example the Phoenix Context `MyApp.Catalogs.Products` to refactor into the Domain Resource Action architecture.

You **MUST** follow this steps:

1. Rename `lib/my_app/catalogs/products.ex` to `lib/my_app/catalogs/catalogs_products_api.ex`
2. Update the module definition from  `MyApp.Catalogs.Products` to `MyApp.Catalogs.CatalogsProductsAPI`.
3. Extract each function body from the new module `MyApp.Catalogs.CatalogsProductsAPI` into its own module with only one public function, named after the action, without the resource name, at `lib/my_app/catalogs/products/<action>/<action>_catalog_product.ex`. For example: `lib/my_app/catalogs/products/create/create_catalog_product.ex` with a function named `create`. The `CatalogsProductsAPI` function header is kept, but its body is now only calling the new action module function, but without using `defdelegate`, otherwise we lose the API contract. You **MUST** also extract private functions like for the `broadcast` action and make them public. Any access from a module to a Domain Resource Action module needs to go through the API module, direct access is **FORBIDDEN**.
4. Update the tests for the now refactored `MyApp.Catalogs.Products` context to test instead `MyApp.Catalogs.CatalogsProductsAPI`. Rename the test file, Module name, and then replace each call to the context with a call to new API module.
5. Run `mix test` to ensure no test is broken after the refactor. If any test is broken fix it before proceeding.

#### 1.5.4 Accessing the Business Logic Layer from the Web Layer

Calls from the web layer, like from a live view or controller are only allowed to a Domain Resource API, that in the folder structure example would be to one of the modules defined at `catalogs_categories_api.ex`, `catalogs_products_api.ex` and `warehouse_stocks_api.ex`. This means that the usual calls to the context need to be replaced with calls to the Domain Resource API. For example, replacing `Catalogs.update_product` with `CatalogsProductsAPI.update_product`. The same needs to be done in the respective tests.

Both a live view and a controller must only have logic to deal with web layer concerns, which usually consists in calling a Domain Resource API with the parameters of the request mapped to existing atoms, and dealing with the returned result to decide if the web layer succeeds or fails the response it needs to send back.

##### 1.5.4.1 Atomized Attributes

The use of atomized attributes is not required to be introduced to existing code, but it's recommended that at some point to refactor the existing code to use them, if not already done.

When this Architecture pattern is analyzed for the first time by an AI Coding Agent it's recommended for it to check if the project is already using atomized parameters to call the Business Logic layer, and if not then ask the developer if he wants to use PLANNING.md to create an Intent with the tasks to implement it, or if he wants to do it himself. The Intent **MUST** be created as specified by the INTENT_SPECIFICATION.md and exemplified by the INTENT_EXAMPLE.md.

##### 1.5.4.2 Example of calling the a Domain Resource API from LiveView

LiveView module trimmed to show only the code for the `edit` handle event, that's enough to illustrate the call to the Domain Resource API with atomized attributes:


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

##### 1.5.4.3 Example to atomize attributes

The below function `atomize_params_map/2` is only a simple example of how to 
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

##### 1.5.4.4 Example to atomize and sanitize attributes

A better approach would be to use a dedicated struct for each Domain Resource to accept input from the external world that atomizes the request input parameters into existing atoms and sanitizes their values.

```elixir
defmodule MyAppWeb.Catalogs.Products.CatalogProductInputSanitized do
  
  # Define here the struct. 
  # The struct **MUST** explicitly enforce the required attributes.

  def sanitize_product_params(input_params) do
    # For each atom key in the struct we want to sanitize the input_params value
    # present in the corresponding string key.

    # You may want to just let it crash if the required keys aren't all present.
    
    # Return the struct. 
  end
end

```

## 2. Milliseconds Timestamps 

By default Phoenix generates schemas and migrations with timestamps in `:utc_datetime` which have a default precision of seconds, thus making it impossible to order records in database queries by the insert or update times, because several records can be inserted or updated in the same second.

The solution is to modify in `config/config.exs`, the `generators` configuration to use `timestamp_type: :utc_datetime_usec` and the code generators will use them by default when creating migrations and schemas.

If migrations or schemas are being created without the use of the code generator they also must use the `:utc_datetime_usec` timestamp.

When this Architecture pattern is analyzed for the first time by an AI Coding Agent it **MUST** check `config/config.exs` to see if the project is already using binary IDs and if not then ask the developer if he wants to use PLANNING.md to create an Intent with the tasks to implement it, or if he wants to do it himself. The Intent **MUST** be created as specified by the INTENT_SPECIFICATION.md and exemplified by the INTENT_EXAMPLE.md.


## 3. Binary IDs

For security reasons this architecture requires that all migrations and schemas use binary IDs for the primary key and foreign keys. 

UUIDV7 as binary IDs are strongly recommended because they can be sorted in database queries, once they are time based.

When this Architecture pattern is analyzed for the first time by an AI Coding Agent it **MUST** check `config/config.exs` to see if the project is already using binary IDs and if not then ask the developer if he wants to use PLANNING.md to create an Intent with the tasks to implement it, or if he wants to do it himself. The Intent **MUST** be created as specified by the INTENT_SPECIFICATION.md and exemplified by the INTENT_EXAMPLE.md.


To add support for UUIDV7 we need to follow this steps:

1. add to `mix.exs` the dependency `{:uuidv7, "~> 0.1"}` and run `mix deps.get`.
2. modify in `config/config.exs`, the `generators` configuration to use `binary_id: {:id, UUIDv7, autogenerate: true}`.
3. modify the default schema template used by the code generator `phx.gen.schema` and `phx.gen.auth` to use `@primary_key {:id, UUIDv7, autogenerate: true}` instead of the default `@primary_key {:id, :binary_id, autogenerate: true}`:
  - `cp deps/phoenix/priv/templates/phx.gen.schema/schema.ex priv/templates/phx.gen.schema/schema.ex`.
  - modify `priv/templates/phx.gen.schema/schema.ex` line with `@primary_key {:id, :binary_id, autogenerate: true}` to `@primary_key {:id, UUIDv7, autogenerate: true}`.
  - `cp deps/phoenix/priv/templates/phx.gen.auth/schema.ex priv/templates/phx.gen.auth/schema.ex`.
  - modify `priv/templates/phx.gen.auth/schema.ex` line with `@primary_key {:id, :binary_id, autogenerate: true}` to `@primary_key {:id, UUIDv7, autogenerate: true}`.
4. in any schema generated without the code generators always ensure that it uses `@primary_key {:id, UUIDv7, autogenerate: true}` instead of the default `@primary_key {:id, :binary_id, autogenerate: true}`.


The above steps can be easily translated to tasks and sub-task when creating an Intent during the planning phase, that **MUST** be created as specified by the INTENT_SPECIFICATION.md and exemplified by the INTENT_EXAMPLE.md.
