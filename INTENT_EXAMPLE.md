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
        And  I shhould see the submit button "Create Product"

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

The Catalog Prodcut CRUD actions will use Domain Resource Action architecture for both the web layer and business logic layer as instructions, guidelines and module examples in the ARCHITECTURE documentation.

The task to implement the Catalog Product CRUD actions will use a TDD first approach, that will adhere to the guidelines specified in the DEVELOPMENT_WORKFLOW.

### 3.2 Tasks

> REQUIRED - List here the Tasks and sub-tasks to complete this Intent.

* [ ] 1.0 - Bussiness Logic layer - **Storage** module for the Catalog Product Action: Create
  - [ ] 1.1 - Create the application code module at `lib/my_app/catalogs/products/create/create_catalog_product_storage.ex` with a public function `create(%Scope{} = scope, %{} = attrs)` and the body of the function should return `:todo` for now.
  - [ ] 1.2 - Create the test code module at `test/my_app/catalogs/products/create/create_catalog_product_storage_test.exs` with the first test to assert a product its created successfully in the database.
  - [ ] 1.3 - Run `mix test test/my_app/catalogs/products/create/create_catalog_product_storage_test.exs` and ensure the test fails, because the application code is returning `:todo`.
  - [ ] 1.4 - Implement the minimal amount of appliction code to make the test pass.
  - [ ] 1.5 - Run `mix test test/my_app/catalogs/products/create/create_catalog_product_storage_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
  - [ ] 1.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/create/create_catalog_product_storage_test.exs` and only proceed to the next test when the current test passes.
* [ ] 2.0 - Bussiness Logic layer - **Core** module for the Catalog Product Action: Create
  - [ ] 2.1 - Create the application code module at `lib/my_app/catalogs/products/create/create_catalog_product_business_rules_core.ex` with a public function `enforce(%Scope{} = scope, %{} = attrs)` and the body of the function should return `:todo` for now.
  - [ ] 2.2 - Create the test code module at `test/my_app/catalogs/products/create/create_catalog_product_business_rules_core_test.exs` with the first test to assert that the Scope as a user that is allowed to perform the `:create` action.
  - [ ] 2.3 - Run `mix test test/my_app/catalogs/products/create/create_catalog_product_business_rules_core_test.exs` and ensure the test fails, because the application code is returning `:todo`.
  - [ ] 2.4 - Implement the minimal amount of appliction code to make the test pass, that will be to at least check that the Scope as a user that is allowed to perform the `:create` action.
  - [ ] 2.5 - Run `mix test test/my_app/catalogs/products/create/create_catalog_product_business_rules_core_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
  - [ ] 2.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/create/create_catalog_product_business_rules_core_test.exs` and only proceed to the next test when the current test passes.
* [ ] 3.0 - Bussiness Logic layer - **Handler** module for the Catalog Product Action: Create
  - [ ] 3.1 - Create the application code module at `lib/my_app/catalogs/products/create/create_catalog_product_handler.ex` with a public function `create(%Scope{} = scope, %{} = attrs)` and the body of the function should return `:todo` for now.
  - [ ] 3.2 - Create the test code module at `test/my_app/catalogs/products/create/create_catalog_product_handler_test.exs` with the first test to assert a product its created successfully.
  - [ ] 3.3 - Run `mix test test/my_app/catalogs/products/create/create_catalog_product_handler_test.exs` and ensure the test fails, because the application code is returning `:todo`.
  - [ ] 3.4 - Implement the minimal amount of appliction code to make the test pass, which calls the core module to enforce business rules and then the storage module to create the product.
  - [ ] 3.5 - Run `mix test test/my_app/catalogs/products/create/create_catalog_product_handler_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
  - [ ] 3.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/create/create_catalog_product_handler_test.exs` and only proceed to the next test when the current test passes.

* [ ] 4.0 - Bussiness Logic layer - **Storage** module for the Catalog Product Action: Read
  - [ ] 4.1 - Create the application code module at `lib/my_app/catalogs/products/read/read_catalog_product_storage.ex` with a public function `read(%Scope{} = scope, uuid)` and the body of the function should return `:todo` for now.
  - [ ] 4.2 - Create the test code module at `test/my_app/catalogs/products/read/read_catalog_product_storage_test.exs` with the first test to assert a product can be successfully readed from the database.
  - [ ] 4.3 - Run `mix test test/my_app/catalogs/products/read/read_catalog_product_storage_test.exs` and ensure the test fails, because the application code is returning `:todo`.
  - [ ] 4.4 - Implement the minimal amount of appliction code to make the test pass.
  - [ ] 4.5 - Run `mix test test/my_app/catalogs/products/read/read_catalog_product_storage_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
  - [ ] 4.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/read/read_catalog_product_storage_test.exs` and only proceed to the next test when the current test passes.
* [ ] 5.0 - Bussiness Logic layer - **Core** module for the Catalog Product Action: Read
- [ ] 5.1 - Create the application code module at `lib/my_app/catalogs/products/read/read_catalog_product_business_rules_core.ex` with a public function `enforce(%Scope{} = scope, uuid)` and the body of the function should return `:todo` for now.
- [ ] 5.2 - Create the test code module at `test/my_app/catalogs/products/read/read_catalog_product_business_rules_core_test.exs` with the first test to assert that the Scope as a user that is allowed to perform the `:read` action.
- [ ] 5.3 - Run `mix test test/my_app/catalogs/products/read/read_catalog_product_business_rules_core_test.exs` and ensure the test fails, because the application code is returning `:todo`.
- [ ] 5.4 - Implement the minimal amount of appliction code to make the test pass, that will be to at least check that the Scope as a user that is allowed to perform the `:read` action.
- [ ] 5.5 - Run `mix test test/my_app/catalogs/products/read/read_catalog_product_business_rules_core_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
- [ ] 5.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/read/read_catalog_product_business_rules_core_test.exs` and only proceed to the next test when the current test passes.
* [ ] 6.0 - Bussiness Logic layer - **Handler** module for the Catalog Product Action: Read
  - [ ] 6.1 - Create the application code module at `lib/my_app/catalogs/products/read/read_catalog_product_handler.ex` with a public function `read(%Scope{} = scope, uuid)` and the body of the function should return `:todo` for now.
  - [ ] 6.2 - Create the test code module at `test/my_app/catalogs/products/read/read_catalog_product_handler_test.exs` with the first test to assert a product its created successfully.
  - [ ] 6.3 - Run `mix test test/my_app/catalogs/products/read/read_catalog_product_handler_test.exs` and ensure the test fails, because the application code is returning `:todo`.
  - [ ] 6.4 - Implement the minimal amount of appliction code to make the test pass, which calls the core module to enforce business rules and then the storage module to fetch the product by UUID.
  - [ ] 6.5 - Run `mix test test/my_app/catalogs/products/read/read_catalog_product_handler_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
  - [ ] 6.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/read/read_catalog_product_handler_test.exs` and only proceed to the next test when the current test passes.

* [ ] 7.0 - Bussiness Logic layer - **Storage** module for the Catalog Product Action: Update
  - [ ] 7.1 - Create the application code module at `lib/my_app/catalogs/products/update/update_catalog_product_storage.ex` with a public function `update(%Scope{} = scope, %CatalogProduct{} = current_product, %{} = attrs)` and the body of the function should return `:todo` for now.
  - [ ] 7.2 - Create the test code module at `test/my_app/catalogs/products/update/update_catalog_product_storage_test.exs` with the first test to assert a product can be successfully updated in the database.
  - [ ] 7.3 - Run `mix test test/my_app/catalogs/products/update/update_catalog_product_storage_test.exs` and ensure the test fails, because the application code is returning `:todo`.
  - [ ] 7.4 - Implement the minimal amount of appliction code to make the test pass.
  - [ ] 7.5 - Run `mix test test/my_app/catalogs/products/update/update_catalog_product_storage_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
  - [ ] 7.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/update/update_catalog_product_storage_test.exs` and only proceed to the next test when the current test passes.
* [ ] 8.0 - Bussiness Logic layer - **Core** module for the Catalog Product Action: Update
- [ ] 8.1 - Create the application code module at `lib/my_app/catalogs/products/update/update_catalog_product_business_rules_core.ex` with a public function `enforce(%Scope{} = scope, %CatalogProduct{} = current_product, %{} = attrs)` and the body of the function should return `:todo` for now.
- [ ] 8.2 - Create the test code module at `test/my_app/catalogs/products/update/update_catalog_product_business_rules_core_test.exs` with the first test to assert that the Scope as a user that is allowed to perform the `:update` action.
- [ ] 8.3 - Run `mix test test/my_app/catalogs/products/update/update_catalog_product_business_rules_core_test.exs` and ensure the test fails, because the application code is returning `:todo`.
- [ ] 8.4 - Implement the minimal amount of appliction code to make the test pass, that will be to at least check that the Scope as user that is allowed to perform the `:update` action.
- [ ] 8.5 - Run `mix test test/my_app/catalogs/products/update/update_catalog_product_business_rules_core_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
- [ ] 8.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/update/update_catalog_product_business_rules_core_test.exs` and only proceed to the next test when the current test passes.
* [ ] 9.0 - Bussiness Logic layer - **Handler** module for the Catalog Product Action: Update
  - [ ] 9.1 - Create the application code module at `lib/my_app/catalogs/products/update/update_catalog_product_handler.ex` with a public function `update(%Scope{} = scope, %CatalogProduct{} = current_product, %{} = attrs)` and the body of the function should return `:todo` for now.
  - [ ] 9.2 - Create the test code module at `test/my_app/catalogs/products/update/update_catalog_product_handler_test.exs` with the first test to assert a product its updated successfully.
  - [ ] 9.3 - Run `mix test test/my_app/catalogs/products/update/update_catalog_product_handler_test.exs` and ensure the test fails, because the application code is returning `:todo`.
  - [ ] 9.4 - Implement the minimal amount of appliction code to make the test pass, which first calls the core module to enforce business rules and then the storage module to update the product.
  - [ ] 9.5 - Run `mix test test/my_app/catalogs/products/update/update_catalog_product_handler_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
  - [ ] 9.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/update/update_catalog_product_handler_test.exs` and only proceed to the next test when the current test passes.

* [ ] 10.0 - Bussiness Logic layer - **Storage** module for the Catalog Product Action: Delete
  - [ ] 10.1 - Create the application code module at `lib/my_app/catalogs/products/delete/delete_catalog_product_storage.ex` with a public function `delete(%Scope{} = scope, uuid)` and the body of the function should return `:todo` for now.
  - [ ] 10.2 - Create the test code module at `test/my_app/catalogs/products/delete/delete_catalog_product_storage_test.exs` with the first test to assert a product can be successfully deleted from the database.
  - [ ] 10.3 - Run `mix test test/my_app/catalogs/products/delete/delete_catalog_product_storage_test.exs` and ensure the test fails, because the application code is returning `:todo`.
  - [ ] 10.4 - Implement the minimal amount of appliction code to make the test pass.
  - [ ] 10.5 - Run `mix test test/my_app/catalogs/products/delete/delete_catalog_product_storage_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
  - [ ] 10.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/delete/delete_catalog_product_storage_test.exs` and only proceed to the next test when the current test passes.
* [ ] 11.0 - Bussiness Logic layer - **Core** module for the Catalog Product Action: Delete
- [ ] 11.1 - Create the application code module at `lib/my_app/catalogs/products/delete/delete_catalog_product_business_rules_core.ex` with a public function `enforce(%Scope{} = scope, uuid)` and the body of the function should return `:todo` for now.
- [ ] 11.2 - Create the test code module at `test/my_app/catalogs/products/delete/delete_catalog_product_business_rules_core_test.exs` with the first test to assert that the Scope as a user that is allowed to perform the `:delete` action.
- [ ] 11.3 - Run `mix test test/my_app/catalogs/products/delete/delete_catalog_product_business_rules_core_test.exs` and ensure the test fails, because the application code is returning `:todo`.
- [ ] 11.4 - Implement the minimal amount of appliction code to make the test pass, that will be to at least check that the Scope as a user that is allowed to perform the `:delete` action.
- [ ] 11.5 - Run `mix test test/my_app/catalogs/products/delete/delete_catalog_product_business_rules_core_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
- [ ] 11.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/delete/delete_catalog_product_business_rules_core_test.exs` and only proceed to the next test when the current test passes.
* [ ] 12.0 - Bussiness Logic layer - **Handler** module for the Catalog Product Action: Delete
  - [ ] 12.1 - Create the application code module at `lib/my_app/catalogs/products/delete/delete_catalog_product_handler.ex` with a public function `delete(%Scope{} = scope, uuid)` and the body of the function should return `:todo` for now.
  - [ ] 12.2 - Create the test code module at `test/my_app/catalogs/products/delete/delete_catalog_product_handler_test.exs` with the first test to assert a product its created successfully.
  - [ ] 12.3 - Run `mix test test/my_app/catalogs/products/delete/delete_catalog_product_handler_test.exs` and ensure the test fails, because the application code is returning `:todo`.
  - [ ] 12.4 - Implement the minimal amount of appliction code to make the test pass, which calls the core module to enforce business rules and then the storage module to fetch the product by UUID.
  - [ ] 12.5 - Run `mix test test/my_app/catalogs/products/delete/delete_catalog_product_handler_test.exs` and ensure the test passes. If it fails, fix and repeat until it succeeds.
  - [ ] 12.6 - Implement the remaining tests, one by one, to cover all scenarios and edge cases. After each test implementation run `mix test test/my_app/catalogs/products/delete/delete_catalog_product_handler_test.exs` and only proceed to the next test when the current test passes.

* [ ] 14.0 - Web Logic layer - Catalog Product CRUD Actions
  - [ ] - 13.1 Run `mix phx.gen.live Catalogs.Products Product products name:string desc:string --web Catalogs.Products` to create all application and test modulea foe the CRUD actions.
  - [ ] - 13.2 Remove the file `lib/my_app/catalogs/products.ex` once the web layer is required to call instead the Catalogs Products API when it needs to access the web layer.
  - [ ] - 13.3 Remove the file `lib/my_app/catalogs/products/product.ex` once it was already create
