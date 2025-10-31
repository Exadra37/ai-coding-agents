# 54 - Feature (Catalogs-Products): Add CRUD actions

> **NOTE:** The AI Coding Agent should be able to get the current Intent number `54` by incrementing by one the number of the last Intent created, the number `53`. If the request of the user isn't clear enough to determine the type of Intent, the Domain and Resource it belongs to and the Intent title itself, then the AI Coding Agent **MUST** explicitly ask the user what they are.

> **NOTE:** Context for the AI Coding Agent and LLM - This document represents a single Intent - a self-contained unit of work focused on implementing a specific piece of functionality. When working with an AI Coding Agent or LLM on this Intent, the user **MUST** start by sharing this document to provide context about what needs to be done.

## 1. Why

> **NOTE:** If the request of the user isn't clear enough to determine the **WHY** for the Intent, then the AI Coding Agent **MUST** explicitly ask the user this Intent objective alongside with some context and relevant background information.

### 1.1 Objective

> **REQUIRED** - Provide a clear statement of what this Intent needs to accomplish.

This feature adds support to create, read, update and delete a Product in the Catalog.

### 1.2 Context

> REQUIRED - Provide the relevant background information and context for this Intent, including why it's needed and how it fits into the larger project

This feature is essential for the back-office to manage products in catalogs.

### 1.3 Depends On Intents

> OPTIONAL - List here Intents this one depends on.

* 50 - Feature (Catalogs-Categories): Add CRUD actions

### 1.4 Related to Intents

> OPTIONAL - List here other Intents that will depend on this one.

* 58 - Feature (Catalogs-Products): Track best selling products

## 2.0 What

> REQUIRED - Use an Event Modelling image or use the Gherkin language to describe WHAT we want to build. Ideally the AI Coding Agent should be able to infer **WHAT** needs to be done from the **WHY**, with minimal or not input from the user.

> OPTIONAL - A Brief introduction based on the user story or requiremnts.

Describing what to build with the Gherking language:

    ```gherkin
    Feature: Catalogs Products - Add CRUD actions

      As a logged in back-office user
      I want to be able to create, read, update, and delete products
      So that I can manage the product catalog.

      Background:
        Given I am logged into the backoffice

      Scenario: New Product Page
        When I click in the button to create a product
        Then I should see the new product page
        And  I should see the form to fill in the Product details
        And  I should see the submit button "Create Product"

      Scenario: Create a new product
        Given I am on the new product page
        When I fill in the product details
        And I click the "Create Product" button
        Then I should see the newly created product's page
        And a success message "Product created successfully"

      Scenario: View a product
        Given a product exists
        When I visit the product's page
        Then I should see the product's details

      Scenario: Update a product
        Given a product exists
        When I visit the product's edit page
        And I update the product details
        And I click the "Update Product" button
        Then I should see the product's page with the updated details
        And a success message "Product updated successfully"

      Scenario: Delete a product
        Given a product exists
        When I am on the product's page
        And I click the "Delete Product" button
        And I confirm the deletion
        Then I should be redirected to the product list page
        And a success message "Product deleted successfully"
    ```

## 3.0 How

 > REQUIRED - Ideally the AI Code Agent should be able figure out the context and the list of all the tasks and sub-tasks needed to complete this Intent.

### 3.1 Implementation Context

> REQUIRED - Provide some implementation context about the tasks listed below.

The Catalog Product CRUD actions will use Domain Resource Action architecture for both the web layer and business logic layer as instructions, guidelines and module examples in the ARCHITECTURE documentation.

The task to implement the Catalog Product CRUD actions will use a TDD first approach, that will adhere to the guidelines specified in the DEVELOPMENT_WORKFLOW.

### 3.2 Tasks

> REQUIRED - List here the Tasks and sub-tasks to complete this Intent.

> REQUIRED - The tasks to define the tests **MUST** be created in the same order of the Gherkin Scenarios, reflect or use their title, and follow the red-green-refactor cycle. If no Gherkin scenarios exist then you **MUST** stop and add them with user feedback. You are allowed to create more tests for scenarios and edges cases not listed in the Gherkin scenarios. No need to create sub-tasks with the steps defined in the development workflow guidelines, like the ones for TDD or Task Completion protocol, because they **MUST** always be followed without the need to have sub-tasks defining them.

* [ ] 1.0 - Generating the Catalogs Products CRUD Actions with LiveView:
  - [ ] 1.1 - Run `mix phx.gen.live Catalogs.Products Product products name:string desc:string --web Catalogs.Products`
  - [ ] 1.2 - Add live routes:
    - [ ] 1.2.1 Add a new `scope "/catalogs/products", MyAppWeb.Catalogs.Products` in `lib/my_app_web/router.ex` that pipes through `:browser` and wraps routes in `live_session :catalogs_products_require_authenticated_user` with `on_mount: [{MyAppWeb.Accounts.Users.UserAuth, :require_authenticated}]`.
    - [ ] 1.2.2 - Inside the live_session, add all product routes removing the duplicated `products` from paths (e.g., `/` for index, `/new` for new, `/:id` for show, `/:id/edit` for edit)
  - [ ] 1.3 - Verify and fix routes: 
    - [ ] 1.3.1 - Run `mix compile` to find all modules with route warnings.
    - [ ] 1.3.2 - Create a list of files with route warnings from the compile output.
    - [ ] 1.3.3 - Use find-and-replace tool to fix all route references in one pass across all files in the list.
    - [ ] 1.3.4 - Run `mix compile` again to verify no route warnings remain.
    - [ ] 1.3.5 - Run `mix test` to find all tests with routes to be fixed.
    - [ ] 1.3.6 - Create a list of files with routed to fix from the tests output
    - [ ] 1.3.7 - Use find-and-replace tool to fix all route references in one pass across all test files in the list.
    - [ ] 1.3.8 - Run `mix test` to ensure all tests using routes are now fixed.
  - [ ] 1.4 - Run `mix ecto.migrate` to apply the new database migrations.
* [ ] 2.0 - Refactor the Phoenix Context `MyApp.Catalogs.Products` into `MyApp.Catalogs.CatalogsProductsAPI` to follow the Domain Resource Action architecture:
  - [ ] 2.1 - mv `lib/my_app/catalogs/products.ex` to `lib/my_app/catalogs/catalogs_products_api.ex` and update the module definition to `MyApp.Catalogs.CatalogsProductsAPI`.
  - [ ] 2.2 - Extract each function body into it's own module with only one public function named after the action, without the resource name, at `lib/my_app/catalogs/products/<action>/<action>_catalog_product.ex`. For example: `lib/my_app/catalogs/products/create/create_catalog_product.ex` with a function named `create`. The `CatalogsProductsAPI` function header is kept, but its body its now only calling the new action module function, but without using `defdelegate`, otherwise we loose the API contract. Private functions from the context also need to be extracted to an action, like `broadcast`.
  - [ ] 2.3 - Update all previous calls from the web layer to the old Phoenix Context `MyApp.Catalogs.Products` into `MyApp.Catalogs.CatalogsProductsAPI`.
  - [ ] 2.4 - Update the tests for the now refactored `MyApp.Catalogs.Products` Phoenix context to test instead `MyApp.Catalogs.CatalogsProductsAPI`. Rename the test file, Module name, and then replace each call to the context with a call to new API module.
  - [ ] 2.4 - Run `mix test` to ensure no test is broken after the refactor. If any test its broken fix it before proceeding.
* [ ] 3.0 - Verify authentication and user scoping in the LiveView tests for Catalogs Products, with the TDD red-green-refactor cycle:
  - [ ] 5.1 - Review and update generated LiveView tests to ensure they test user scoping on resources.
  - [ ] 5.2 - Add test for index page displaying only current user's articles and not other users' articles
  - [ ] 5.3 - Add test for preventing view of another user's article
  - [ ] 5.4 - Add test for preventing edit of another user's article
  - [ ] 5.5 - Add test for preventing deletion of another user's article
* [ ] 4.0 - Add navigation links to the new Catalogs Products resource into the top menu bar with a red-green-refactor TDD approach:
  - [ ] 4.1 - Add the tests to the home page test file `test/my_app_web/controllers/page_controller_test.exs` to ensure the top menu as a link to each Catalogs Products action as a drop-down menu. 
  - [ ] 4.1 - Find the top menu bar on the app root layout at `lib/my_app_web/components/layouts/root.html.heex` and add the links for each action as a drop-down.
