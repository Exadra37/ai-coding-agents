# Authentication - Phoenix Code Generator

Phoenix ships with an [Authentication code generator](https://hexdocs.pm/phoenix/mix_phx_gen_auth.html), which will be the preferred to use in any project that requires authentication unless the user or the project README says otherwise.

**IMPORTANT:** Before adding Authentication as instructed here, an Intent needs to be created with instruction from points 2. and 3. of this document, with user approval. The Intent **MUST** be created as specified by the INTENT_SPECIFICATION.md and exemplified by the INTENT_EXAMPLE.md.

## 1. Overview

The generator by default:

* uses magic links, not email and password combo, but it can be enabled by the user after email confirmation.
* adds the routes to `router.ex`.
* adds the tests.
* adds a [Scope](https://hexdocs.pm/phoenix/mix_phx_gen_auth.html#scopes) module since Phoenix 1.8. The `%Scope{}` is then passed calls to the business logic layer (`lib/my_app/*`) to prevent unauthorized access to other users resources.
* doesn't include a production mailer.

## 2. How to Install

1. Run `mix phx.gen.auth Accounts.Users User users --live --hashing-lib argon2 --web Accounts.Users`.
2. Run `mix deps.get`.
4. Run `mix ecto.migrate`.
5. Run `mix ecto.migrate`.

## 3. How to Add Routes that Require Authentication

For example, when you create a LiveView with `mix phx.gen.live Catalogs.Products Product products name:string desc:string --web Catalogs.Products` then it will ask you to add this routes:

```elixir
scope "/catalogs/products", MyAppWeb.Catalogs.Products do
  pipe_through :browser
  ...

  live "/products", ProductLive.Index, :index
  live "/products/new", ProductLive.Form, :new
  live "/products/:id", ProductLive.Show, :show
  live "/products/:id/edit", ProductLive.Form, :edit
end
```

The routes inside the scope `catalogs/products` **MUST** be wrapped in a live session with a unique name in the router, therefore we will name it with this pattern `:<domain>_<resource>_require_authenticated_user`:

```elixir
scope "/catalogs/products", MyAppWeb.Catalogs.Products do
  pipe_through :browser
  
  live_session :catalogs_products_require_authenticated_user,
      on_mount: [{MyAppWeb.Accounts.Users.UserAuth, :require_authenticated}] do
    live "/", ProductLive.Index, :index
    live "/new", ProductLive.Form, :new
    live "/:id", ProductLive.Show, :show
    live "/:id/edit", ProductLive.Form, :edit
  end
end
```

**CRITICAL:** For security reasons you **MUST** use always the `on_mount` with `:require_authenticated`. You **MUST NOT** use the `on_mount` with `:mount_current_scope` unless explicitly asked by the user. The use of `:mount_current_scope` will not protect the route at the router level when an attacker replays an authenticated request, instead it will crash somewhere else on the code base where the current scope needs to be used and it's `nil`, which can be at business layer level, before doing a database request. It's enough for the developer or AI agent to not use a scope in the query to make the attacker happy.

The live session was named `:catalogs_products_require_authenticated_user`, as per the above pattern, which guarantees that it will be always unique in the router.
 
Notice, that each live route had `products` removed from it, which its required when we use the option `--web` with the format `-web <DomainPlural>.<ResourcePlural>`, e.g. `--web Catalogs.Products`. This is because of a bug in the code generators that will create routes with the resource duplicated in the path, that in this case was `/catalogs/products/products/...`. 

Now its also required to fix all routes created by the code generator in other files, and to fix them:
1. You **MUST** run `mix compile` to find all module files with routes to be fixed. 
2. You **MUST** then create a list of files from the the output of `mix compile` that have routes to be fixed.
3. You **MUST** feed the list of files to a **find and replace tool** (e.g. `find` in Linux), to fix all routes in only one pass. You **MUST NOT** try to fix one module at a time, because that will be an exhaustive and time consuming task. 

## 4. How to Add a Production Mailer

### 4.1 Runtime Configuration

In `runtime.exs` find `if config_env() == :prod do` and then add:

```elixir
if config_env() == :prod do
  config :swoosh, :api_client, Swoosh.ApiClient.Req

  config :em_canvas, EmCanvas.Mailer,
    adapter: Swoosh.Adapters.ZeptoMail,
    base_url: "https://api.zeptomail.eu/v1.1",
    api_key: System.fetch_env!("API_KEY_EMAIL_PROVIDER")

```

### 4.2 Handling Zepto Mail API Errors

Find in `lib/my_app/live/accounts/users/user_live/registration.ex`:

```elixir
:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
```

And then add:

```elixir
# We need to be running with MIX_ENV=prod to reach this error, which can
# occur when the ZeptoMail adapter is not configured correctly. For
# example, with an invalid API Key or with the default URL for USA, which
# doesn't match the one in the account, that may be for EU.
{:error, reason} ->
  Logger.error(%{
    tracking: EmCanvas.build_log_tracking(socket.id),
    reason: reason,
    user_params: user_params
  })

  {:noreply,
   socket
   |> put_flash(
     :error,
     "Failed to send the magic link, please try again. Contact us at #{EmCanvas.support_email()} if the problem persists."
   )}
```
