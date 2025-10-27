# 54 - Feature (Warehouses-Stocks): Track Items Stock

> **NOTE:** The AI Coding Agent should be able to get the current Intent number `54` by incrementing by one the number of the last Intent created, the number `53`. If the request of the user isn't clear enough to determine the type of Intent, the Domain and Resource it belongs to and the Intent title itself, then the AI Coding Agent **MUST** explicitly ask the user what they are.
  
> **NOTE:** Context for the AI Coding Agent and LLM - This document represents a single Intent - a self-contained unit of work focused on implementing a specific piece of functionality. When working with an AI Coding Agent or LLM on this Intent, the user **MUST** start by sharing this document to provide context about what needs to be done.

## 1. Why

> **NOTE:** If the request of the user isn't clear enough to determine the **WHY** for the Intent, then the AI Coding Agent **MUST** explicitly ask the user this Intent objective alongside with some context and relevant background information.

### 1.1 Objective

> **REQUIRED** - Provide a clear statement of what this Intent needs to accomplish.

This feature adds support to track items stock across all warehouses.

### 1.2 Context 

> REQUIRED - Provide the relevant background information and context for this Intent, including why it's needed and how it fits into the larger project

This feature is the foundation that other features will build on top. For example: to keep stock under control, to send notifications about low stock, out of stock or back in stock, for targets like customers, sales, management, business intelligence, analytics and metrics.

### 1.3 Depends On Intents

> OPTIONAL - List here Intents this one depends on.

* 50 - Feature (Warehouses-Shelves): Track items removed from shelves

### 1.4 Related to Intents

> OPTIONAL - List here other Intents that will depend on this one.

* 58 - Feature (Warehouses-Analytics): Add dashboard to track items lower stock average

## 2.0 What

> REQUIRED - Use an Event Modelling image or use the Gherkin language to describe WHAT we want to build. Ideally the AI Coding Agent should be able to infer **WHAT** needs to be done from the **WHY**, with minimal or not input from the user.

Describing what to build with the Gherking language:

    ```gherkin
    Feature: Warehouses Stocks - Track Items Stock
    
      A background process subscribes to notifications from items being removed from the Warehouses shelves and when receives a notification it verifies the current stock and if the low stock threshold for the item was reached for the given Warehouse, and always emits a `warehouse_current_item_stock_status` notification for the current item stock on that Warehouse with the current stock quantity and a item stock status in one of `in_stock`, `low_stock`, `out_of_stock`.
      
      The notification is required to always have the fields: `warehouse_id`, `item_id`, `shelf_item_pickup_id`, `item_stock_status`, `minimal_stock_threshold` and `current_quantity_stocked`.
      
      
      Scenario: Item current stock is `0`
        Given a notification `warehouse_shelves_item_removed` is received
        When the item current stock is `0`
        Then emits a notification with all required fields and a `item_stock_status` of `out_of_stock`.
        
      Scenario: Item current stock below or equal to minimal stock threshold
        Given a notification `warehouse_shelves_item_removed` is received
        When the threshold for the minimal stock quantity of an item is `10`
        Then checks the current quantity in stock for the item on the given Warehouse
        Then subtracts the quantity removed from the shelves from the current quantity 
        And if the quantity is equal or less to the threshold of `10`
        Then emits a notification with all required fields and a `item_stock_status` of `low_stock`. 
        
      Scenario: Item current stock above the minimal stock threshold
        Given a notification `warehouse_shelves_item_removed` is received
        When the threshold for the minimal stock quantity of an item is `10`
        Then checks the current quantity in stock for the item
        Then subtracts the quantity removed from the shelves from the current quantity 
        And if the quantity is greater to the threshold of `10`
        Then emits a notification with all required fields and a `item_stock_status` of `in_stock`. 
    ```

## 3.0 How

 > REQUIRED - Ideally the AI Code Agent should be able figure out the context and the list of all the tasks and sub-tasks needed to complete this Intent.

### 3.1 Implementation Context

> OPTIONAL - Provide some implementation context about the tasks listed below.

The tasks will follow the Domain Resource Action architecture to create two actions, `track_item_stock/0` and `find_item_stock_status/2` on the same Domain Resource `WarehousesStocks`. 

The `track_item_stock/0` action will be responsible to start a supervised background process that will subscribe and listen to notifications for items removed from shelves in all the Warehouses. The background process is kept running as long as the application is running.

The `find_item_stock_status/2` action will be used by the background process to trigger the current item stock verification and emit the notification `warehouse_current_item_stock_status` as defined in [2.0 What](#2-what). 

### 3.2 Tasks

> REQUIRED - List here the Tasks and sub-tasks to complete this Intent.

* [ ] 1.0 - Create the Domain Resource Action folder skeleton, with their respective modules, for the `Warehouses` Domain, `Stocks` Resource and `track_item_stock` Action:
  - [ ] 1.1 - Create the folder skeleton for the Business Logic at `lib/online_shop/warehouses/stocks/track_item_stock`
  - [ ] 1.2 - Create the folder skeleton to test the Business Logic at `test/online_shop/warehouses/stocks/track_item_stock`
  - [ ] 1.3 - Add the function for the action `track_item_stock` to the Domain Resource API module `WarehousesStocksAPI` to invoke the Domain Resource Action `TrackItemStockBackgroundProcess.track/0`.
  - [ ] 1.4 - Add the function for the action `find_item_stock_status` to the Domain Resource API module `WarehousesStocksAPI` to invoke the `FindItemStockStatusHandler.find/2`.
* [ ] 2.0 - Use a TDD approach for writing tests for all scenarios and edge cases at `FindItemStockStatusStorageTest`, but implement one test at a time, followed by writing the minimal amount of code (easy to read and reason about) required for it to pass at `FindItemStockStatusStorage.item_stock_by_id/2`:
  - [ ] 2.1 - Implement the first test for the database query to get the current stock for a given item by ID and warehouse ID at `FindItemStockStatusStorageTest`.
  - [ ] 2.2 - Run `mix test` to ensure the test is failing (query logic not implemented yet).
  - [ ] 2.3 - Implement the logic to query the database to get the current stock for a given item by ID and warehouse ID at `FindItemStockStatusStorage.item_stock_by_id/2`.
  - [ ] 2.4 - Run `mix test` to ensure the test passes. If it fails, fix and repeat until it succeeds. 
  - [ ] 2.5 - Implement the remaining tests, one by one, at `FindItemStockStatusStorageTest` to cover all scenarios and edge cases. After each test implementation run `mix test` and only proceed to the next test when the current test passes.
* [ ] 3.0 - Use a TDD approach for writing tests for all scenarios and edge cases at `FindItemStockStatusCoreTest`, but implement one test at a time, followed by writing the minimal amount of code (easy to read and reason about) required for it to pass at `FindItemStockStatusCore.find/2`:
  - [ ] 3.1 - Implement the first test for the database query to get the current stock for a given item by ID and warehouse ID at `FindItemStockStatusCoreTest`.
  - [ ] 3.2 - Run `mix test` to ensure the test is failing (core business logic not implemented yet).
  - [ ] 3.3 - Implement the business logic to verify if the current stock is below the minimal low stock threshold at `FindItemStockStatusCore.find/2`.
  - [ ] 3.4 - Run `mix test` to ensure the test passes. If it fails, fix and repeat until it succeeds. 
  - [ ] 3.5 - Implement the remain g tests, one by one, at `FindItemStockStatusCoreTest` to cover all scenarios and edge cases. After each test implementation run `mix test` and only proceed to the next test when the current test passes.
* [ ] 4.0 - Use a TDD approach for writing tests for all scenarios and edge cases at `FindItemStockStatusHandlerTest`, but implement one test at a time, followed by writing the minimal amount of code (easy to read and reason about) required for it to pass at `FindItemStockStatusHandler.find/2`:
  - [ ] 4.1 - Implement the first test for the database query to get the current stock for a given item by ID and warehouse ID at `FindItemStockStatusHandlerTest`.
  - [ ] 4.2 - Run `mix test` to ensure the test is failing (core business logic not implemented yet).
  - [ ] 4.3 - Implement the logic to call `FindItemStockStatusStorage.item_stock_by_id/2` and `WarehousesStocksAPI.item_minimal_stock_threshold/2` to then be able to call `FindItemStockStatusHandler.find/2`. This call`WarehousesStocksAPI.item_minimal_stock_threshold/2` is already implemented in the code base.
  - [ ] 4.4 - If the item is low in stock then emit the notifications 
  - [ ] 4.5 - Run `mix test` to ensure the test passes. If it fails, fix and repeat until it succeeds. 
  - [ ] 4.6 - Implement the remaining tests, one by one, at `FindItemStockStatusHandlerTest` to cover all scenarios and edge cases. After each test implementation run `mix test` and only proceed to the next test when the current test passes.
* [ ] 5.0 - Use a TDD approach for writing tests for all scenarios and edge cases at `TrackItemStockBackgroundProcessTest`, but implement one test at a time, followed by writing the minimal amount of code (easy to read and reason about) required for it to pass at `TrackItemStockBackgroundProcess.start_link/1`:
- [ ] 5.1 - Implement the first test to ensure the background process can be started when the application boots, at `TrackItemStockBackgroundProcessTest`.
- [ ] 5.2 - Run `mix test` to ensure the test is failing (logic not implemented yet).
- [ ] 5.3 - Implement the logic for `TrackItemStockBackgroundProcess.start_link/1`.
- [ ] 5.4 - Run `mix test` to ensure the test passes. If it fails, fix and repeat until it succeeds. 
- [ ] 5.5 - Implement the remaining tests, one by one, at `TrackItemStockBackgroundProcessTest` to cover all scenarios and edge cases. After each test implementation run `mix test` and only proceed to the next test when the current test passes.
