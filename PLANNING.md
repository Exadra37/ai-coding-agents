# Planning

When a user makes a request, and before proposing any code, the AI Coding Agent MUST discuss the request with the user to create an Intent and a list of Tasks and sub-tasks to complete the user request.

## Intents and Tasks

An Intent is a self-contained document that explains the user request in a markdown file that has one H1 header as the title, followed by some required and optional sections H2 headers.

**IMPORTANT: The intent document **MUST** strive to keep explanations brief, concise and straigh to the point. Developers prefer communication that's as straighforward as possible. Start by the most important parts that need to be told, follow with some brief context, and only add details when it makes sense.**

### Required H1 Header Title

* The title MUST be the first line of the file and be short and concise and include the type of Intent and the Domain it refers to. The format for the title is `<typeofintent> (domain-resource): intent`, e.g. `54 - Feature (wharehouses-stocks): Track items with low stock`. 
  - the type of intent may be a `feature`, an `enhancement`, a `bug`, or something else. It needs to be defined as a single word without spaces, use only letters, numbers, `:`,  `-` and `_`.

### Required H2 Headers Sections

* **WHY** the user as asked to do something, the intention.
* **WHAT** the user wants to build, which can be provided by the user as event modelling images, usinng the Gherkin language or as plain text. The AI Coding assistant can also help the user and infer the WHAT from the WHY (the intention), by asking relevant questions, if needed.  
* **HOW** the step-by-step that the AI Coding Agent plans to follow to build WHAT the user requested, the tasks and sub-tasks.

### Optional H2 Headers Sections

* **TARGET AUDIENCE** The target audience for the request when makes sense.
* **CONSTRAINS** If nay exist they must be listed and briefly explained in a concise way.
* **DESIGN DECISIONS** The key design decisions, their rationale and trade-offs.
* **ALTERNATIVES CONSIDERED** Other approaches that were considered and why they weren't chosen.
* **ARCHITECTURE** Architecture decisions, considerations and diagrams if applicable. By default the Domain Resource Action architecture pattern is used as per @ARCHITECTURE.md.
* **IMPLEMENTATION** Notes on expected implementation details, key decisions, the expected challenges, and their possible resolutions.
* **TECHNICAL DETAILS** Specific technical details and considerations. For example what packages to use, and why they were chosen over other alternatives.
* **CODE SNIPPETS AND EXAMPLES** Provide them when the problem is complex to guide and help the AI Code Agent to better resolve them as you whish.
* **CHALLENGES & SOLUTIONS** Challenges encountered during implementation and how they were resolved. This only makes sense to add after the Intent is implemented, and didn't went as planned.

You MUST ask the user to approove the Intent and save it to `.intent/` directory at the root of the project. The file name must follow the format `<number>_<typeofintent_<domain-resource><intent-dashed>`, e.g. `54_feature_wharehouses-stocks_track-items-with-low-stock`.


### Intent Example

```markdown
# 54 - Feature (Wharehoeuses-Stocks): Track Items with Low Stock

> # The AI Coding Agent should be able to get the current Itent number `54` by incrementing by one the number of the last Intent created, the number `53`. If the request of the user isn't clear enough to detemine the type of Intent, the Domain and Resource it belongs to and the Intent title itself, then the AI Coding Agent **MUST** explicitely ask the user what they are.

> # Context for the AI Coding Agent and LLM - This document represents a single Intent - a self-contained unit of work focused on implementing a specific piece of functionality. When working with an AI Coding Agent or LLM on this Intent, the user **MSUT** start by sharing this document to provide context about what needs to be done.

## Why

> # If the request of the user isn't clear enough to detemine the **WHY** for the Intent, then the AI Coding Agent **MUST** explicitely ask the user this Intent objective alongside with some context and relevant background information.

### Objective

> # REQUIRED - Provide a clear statement of what this steel thread aims to accomplish

This feature adds support to track items with low stock accross all wharehouses.

### Context 

> # REQUIRED - Provide the relevant background information and context for this Intent, including why it's needed and how it fits into the larger project

This feature is the foundation to later enable to build other features, like automations to keep stock under control, notifications for users, sales and management, business inteligence, analytics and metrics.

### Depends On Intents

> # OPTIONAL - List here Intents this one depends on.

* 50 - Feature (Wharehoeuses-Shelfes): Track items removed from shelfes

### Related to Intents

> # OPTIONAL - List here other Intents that will depend on this one.

* 58 - Feature (Wharehoeuses-Analytics): Add dashboard  for lower stock items average

## What

> # REQUIRED - Use an Event Modelling image or use the Gherkin language to describe WHAT we want to build. Ideally the AI Coding Agent should be able to infer **WHAT** needs to be done from the **WHY**, with miniaml or not input from the user.

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

> # REQUIRED - List here the Tasks and subtasks to complete this Intent. Ideally the AI Code Agent should be able to determin all the task needed.

### Tasks

* [ ] 1.0 - Create the Domain Resource Action Skeleton for the `Wharehouses` Domain, `Stocks` Resource and `track_item_low_stock` Action:
  - [ ] 1.1 - Create folder skeleton for the Business Logic at `lib`

```
