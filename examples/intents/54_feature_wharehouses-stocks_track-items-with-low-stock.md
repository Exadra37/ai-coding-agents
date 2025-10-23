# 54 - Feature (Wharehoeuses-Stocks): Track Items with Low Stock

> **NOTE:** The AI Coding Agent should be able to get the current Intent number `54` by incrementing by one the number of the last Intent created, the number `53`. If the request of the user isn't clear enough to detemine the type of Intent, the Domain and Resource it belongs to and the Intent title itself, then the AI Coding Agent **MUST** explicitely ask the user what they are.
  
> **NOTE:** Context for the AI Coding Agent and LLM - This document represents a single Intent - a self-contained unit of work focused on implementing a specific piece of functionality. When working with an AI Coding Agent or LLM on this Intent, the user **MSUT** start by sharing this document to provide context about what needs to be done.

## 1. Why

> **NOTE:** If the request of the user isn't clear enough to detemine the **WHY** for the Intent, then the AI Coding Agent **MUST** explicitely ask the user this Intent objective alongside with some context and relevant background information.

### 1.1 Objective

> **REQUIRED** - Provide a clear statement of what this Intent needs to accomplish.

This feature adds support to track items with low stock accross all wharehouses.

### 1.2 Context 

> REQUIRED - Provide the relevant background information and context for this Intent, including why it's needed and how it fits into the larger project

This feature is the foundation to later enable to build other features, like automations to keep stock under control, notifications for users, sales and management, business inteligence, analytics and metrics.

### 1.3 Depends On Intents

> OPTIONAL - List here Intents this one depends on.

* 50 - Feature (Wharehoeuses-Shelfes): Track items removed from shelfes

### 1.4 Related to Intents

> OPTIONAL - List here other Intents that will depend on this one.

* 58 - Feature (Wharehoeuses-Analytics): Add dashboard  for lower items stock average

## 2.0 What

> REQUIRED - Use an Event Modelling image or use the Gherkin language to describe WHAT we want to build. Ideally the AI Coding Agent should be able to infer **WHAT** needs to be done from the **WHY**, with miniaml or not input from the user.

Describing what to build with the Gherking language:

    ```gherkin
    Feature: Wharehouses Stocks - Track items with low stock
    
      A background process subscribes to pubsub notifications from items being removed from the storage shelfes and when receives a notification it verifies if the low stock threshold for the item, in the given Warehouse, was reached, and always emits a low stock pubsub notification for the item on that Warehouse, where one 
      
      Scenario: Item below or equal to minimal stock threshold
        Given a threshold of `10` for the minimal stock quantity of an item
        When a notification `wharehouse_shelfes_item_removed` is received
        Then check the current quantity in stock for the item on the given Wharehoeuse
        Then subtract the quantity removed from the shelfes from the current quantity 
        And if the quantiy is equal or less to the threshold of `10`
        Then emit a notification `wharehouse_stock_item_status` with the `wharehouse_id`, `item_id`, `shelf_item_pickup_id`, `low_stock?`, `minimal_stock_threshold` and `current_quantity_stocked`.
        
      Scenario: Item above the minimal stock threshold
        Given a threshold of `10` for the minimal stock quantity of an item
        When a notification `wharehouse_shelfes_item_removed` is received
        Then check the current quantity in stock for the item
        Then subtract the quantity removed from the shelfes from the current quantity 
        And if the quantiy is greater to the threshold of `10`
        Then emit a notification `wharehouse_item_current_stock` with the `wharehouse_id`, `item_id`, `shelf_item_pickup_id`,  `low_stock?`, `minimal_stock_threshold`, `current_quantity_stocked` and `quantity_removed`.
      
    ```

## 3.0 How

 > REQUIRED - Ideally the AI Code Agent should be able figure out the context and the list of all the tasks and sub-tasks needed to complete this Intent.

### 3.1 Implementation Context

> OPTIONAL - Provide some implementation context about the tasks listed below.

The tasks will follow the Domain Resource Action architecture to create two actions, `track_low_stock_item/0` and `low_stock_item?/2` on the same Domain Resource `WharehousesStocks`. 

The `track_low_stock_item/0` action will be responsible to start a supervised background process that will subscribe and listen to pubsub notifications for items removed from shelfes in all the Wharehoeuses. The background process is kept running as long as the application is running.

The `low_stock_item?/2` action will be used by the background process to trigger the low stock verification and emit the notification `wharehouse_stock_item_status` as defined in [2.0 What](#2-what). 

### 3.2 Tasks

> REQUIRED - List here the Tasks and subtasks to complete this Intent.

* [ ] 1.0 - Create the Domain Resource Action folder skeleton for the `Wharehouses` Domain, `Stocks` Resource and `track_low_stock_item` Action:
  - [ ] 1.1 - Create the folder skeleton for the Business Logic at `lib/online_shop/wharehouses/stocks/track_low_stock_item`
  - [ ] 1.2 - Create the folder skeleton for the Business Logic at `test/online_shop/wharehouses/stocks/track_low_stock_item`
  - [ ] 1.3 - Add the Elixir modules placeholders (no business logic yet, just empty functions) to the action folder scheleton:
  - [ ] 1.4 - Add the function for the action `track_low_stock_item` to the Domain Resource API module `WarehousesStocksAPI` to invoke the Domain Resource Action `TrackLowStockItemBackgroundProcess.track/0`.
  - [ ] 1.5 - Add the function for the action `low_stock_item?` to the Domain Resource API module `WarehousesStocksAPI` to invoke the `LowStockItemHandler.low_stock?/2`.
* [ ] 2.0 - Use a TDD approach for writing tests for all scenarios and edge cases at `LowStockItemStorageTest`, but implement one test at a time, followed by writing the minimal amount of clean code required for it to pass at `LowStockItemStorage.item_stock_by_id/2`:
- [ ] 2.1 - Implement the first test for the database query to get the current stock Add the Business Logic for a given item by ID and wharehouse ID at `LowStockItemStorageTest`.
  - [ ] 2.2 - Run `mix test` to ensure the test is failing (query logic not implemented yet).
  - [ ] 2.3 - Implement the logic to query the database to get the current stock for a given item by ID and wharehouse ID at `LowStockItemStorage.item_stock_by_id/2`.
  - [ ] 2.4 - Run `mix test` to ensure the test passes. If it fails, fix and repeat until it succeeds. 
  - [ ] 2.5 - Implement the remaing tests, one by one, at `LowStockItemStorageTest` to cover all scenarios and edge cases. After each test implementation run `mix test` and only procced to the next test whne the current test passes.
* [ ] 3.0 - Use a TDD approach for writing tests for all scenarios and edge cases at `LowStockItemCoreTest`, but implement one test at a time, followed by writing the minimal amount of clean code required for it to pass at `LowStockItemCore.low_stock?/2`:
- [ ] 3.1 - Implement the first test for the database query to get the current stock Add the Business Logic for a given item by ID and wharehouse ID at `LowStockItemCoreTest`.
  - [ ] 3.2 - Run `mix test` to ensure the test is failing (core business logic not implemented yet).
  - [ ] 3.3 - Implement the busines logic to verify if the current stock is below the minimal low stock threshold at `LowStockItemCore.low_stock?/2`.
  - [ ] 3.4 - Run `mix test` to ensure the test passes. If it fails, fix and repeat until it succeeds. 
  - [ ] 3.5 - Implement the remaing tests, one by one, at `LowStockItemCoreTest` to cover all scenarios and edge cases. After each test implementation run `mix test` and only procced to the next test whne the current test passes.
* [ ] 4.0 - Use a TDD approach for writing tests for all scenarios and edge cases at `LowStockItemHandlerTest`, but implement one test at a time, followed by writing the minimal amount of clean code required for it to pass at `LowStockItemHandler.low_stock?/2`:
- [ ] 4.1 - Implement the first test for the database query to get the current stock Add the Business Logic for a given item by ID and wharehouse ID at `LowStockItemHandlerTest`.
  - [ ] 4.2 - Run `mix test` to ensure the test is failing (core business logic not implemented yet).
  - [ ] 4.3 - Implement the logic to call `LowStockItemStorage.item_stock_by_id/2` and `WharehousesStocksAPI.item_minimal_stock_threshold/2` to then be able to call `LowStockItemHandler.low_stock?/2`. This call`WharehousesStocksAPI.item_minimal_stock_threshold/2` is already implemented in the code base.
  - [ ] 4.4 - If the item is low in stock then emit the notifications 
  - [ ] 4.4 - Run `mix test` to ensure the test passes. If it fails, fix and repeat until it succeeds. 
  - [ ] 4.5 - Implement the remaing tests, one by one, at `LowStockItemHandlerTest` to cover all scenarios and edge cases. After each test implementation run `mix test` and only procced to the next test whne the current test passes.
