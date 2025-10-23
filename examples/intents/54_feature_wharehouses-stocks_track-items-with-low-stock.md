# 54 - Feature (Wharehoeuses-Stocks): Track Items with Low Stock

> **NOTE:** The AI Coding Agent should be able to get the current Intent number `54` by incrementing by one the number of the last Intent created, the number `53`. If the request of the user isn't clear enough to detemine the type of Intent, the Domain and Resource it belongs to and the Intent title itself, then the AI Coding Agent **MUST** explicitely ask the user what they are.
  
> **NOTE:** Context for the AI Coding Agent and LLM - This document represents a single Intent - a self-contained unit of work focused on implementing a specific piece of functionality. When working with an AI Coding Agent or LLM on this Intent, the user **MSUT** start by sharing this document to provide context about what needs to be done.

## Why

> **NOTE:** If the request of the user isn't clear enough to detemine the **WHY** for the Intent, then the AI Coding Agent **MUST** explicitely ask the user this Intent objective alongside with some context and relevant background information.

### Objective

> **REQUIRED** - Provide a clear statement of what this Intent needs to accomplish.

This feature adds support to track items with low stock accross all wharehouses.

### Context 

> REQUIRED - Provide the relevant background information and context for this Intent, including why it's needed and how it fits into the larger project

This feature is the foundation to later enable to build other features, like automations to keep stock under control, notifications for users, sales and management, business inteligence, analytics and metrics.

### Depends On Intents

> OPTIONAL - List here Intents this one depends on.

* 50 - Feature (Wharehoeuses-Shelfes): Track items removed from shelfes

### Related to Intents

> OPTIONAL - List here other Intents that will depend on this one.

* 58 - Feature (Wharehoeuses-Analytics): Add dashboard  for lower stock items average

## What

> REQUIRED - Use an Event Modelling image or use the Gherkin language to describe WHAT we want to build. Ideally the AI Coding Agent should be able to infer **WHAT** needs to be done from the **WHY**, with miniaml or not input from the user.

Describing what to build with the Gherking language:

    ```gherkin
    Feature: Wharehouses Stocks - Track items with low stock
    
      An automation running in the background subscribes to notifications from items being removed from the storage shelfes and track verifies if the low stock threshold for the item in the given Warehouse was reached, and if so emits a low stock event for the item on that Warehouse.
      
      Scenario: Item below or equal to minimal stock threshold
        Given a threshold of `10` for the minimal stock quantity of an item
        When an event `wharehouse_shelfes_item_removed` is received
        Then check the current quantity in stock for the item on the given Wharehoeuse
        Then subtract the quantity removed from the shelfes from the current quantity 
        And if the quantiy is equal or less to the threshold of `10`
        Then emit an event `wharehouse_item_low_stock` with the `wharehouse_id`, `item_id`, `item_sku` `item_name`, `minimal_stock_threshold` and `current_quantity_stocked`.
        And emit an event `wharehouse_item_current_stock` with the `wharehouse_id`, `item_id`, `item_sku` `item_name`, `minimal_stock_threshold`, `current_quantity_stocked` and `quantity_removed`.
        
      Scenario: Item above the minimal stock threshold
        Given a threshold of `10` for the minimal stock quantity of an item
        When an event `wharehouse_shelfes_item_removed` is received
        Then check the current quantity in stock for the item
        Then subtract the quantity removed from the shelfes from the current quantity 
        And if the quantiy is greater to the threshold of `10`
        Then emit an event `wharehouse_item_current_stock` with the `wharehouse_id`, `item_id`, `item_sku` `item_name`, `minimal_stock_threshold`, `current_quantity_stocked` and `quantity_removed`.
      
    ```

## How

> REQUIRED - List here the Tasks and subtasks to complete this Intent. Ideally the AI Code Agent should be able to determin all the task needed.

### Tasks

* [ ] 1.0 - Create the Domain Resource Action Skeleton for the `Wharehouses` Domain, `Stocks` Resource and `track_item_low_stock` Action:
  - [ ] 1.1 - Create folder skeleton for the Business Logic at `lib`
