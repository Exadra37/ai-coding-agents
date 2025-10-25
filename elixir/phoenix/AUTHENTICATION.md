# Authentication

Phoenix ships with an [Authentication code generator](https://hexdocs.pm/phoenix/mix_phx_gen_auth.html), which will be the preferred to use in any project that requires authentication unless the user or the project README says otherwise.

**IMPORTANT:** Before adding Authentication as instructed here, an Intent needs to be created with instruction from points 2. and 3. of this document, with user approval. The Intent **MUST** be created as specified by the @INTENT_SPECIFICATION.md and exemplified by the @INTENT_EXAMPLE.md.

## 1. Overview

The generator by default:

* uses magic links, not email and password combo, but it can be enabled by the user after email confirmation.
* adds the routes to `router.exs`.
* adds the tests.
* adds a [Scope](https://hexdocs.pm/phoenix/mix_phx_gen_auth.html#scopes) module since Phoenix 1.8. The `%Scope{}` is then passed calls to the business logic layer to prevent unauthorized access to other users resources.
* doesn't include a production mailer.

## 2. How to Install

1. Run `mix phx.gen.auth Accounts.Users User users --live --hashing-lib argon2 --web Accounts.Users`.
2. Run `mix deps.get`.
4. Run `mix ecto.migrate`.
5. Run `mix ecto.migrate`.

## 3. How to Add a Production Mailer

### 3.1 Runtime Configuration

In `runtime.exs` find `if config_env() == :prod do` and then add:

```elixir
if config_env() == :prod do
  config :swoosh, :api_client, Swoosh.ApiClient.Req

  config :em_canvas, EmCanvas.Mailer,
    adapter: Swoosh.Adapters.ZeptoMail,
    base_url: "https://api.zeptomail.eu/v1.1",
    api_key: System.fetch_env!("API_KEY_EMAIL_PROVIDER")

```

### 3.2 Handling Zepto Mail API Errors

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

