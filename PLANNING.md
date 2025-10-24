# Planning

When a user makes a request, and before proposing any code, the AI Coding Agent **MUST** discuss the request with the user to create an Intent with a list of Tasks and sub-tasks to complete the user request. This means that for any new request, the first step will always be to propose and create an Intent file for user approval, before writing any application or test code until the approves the Intent, as per the more detailed instructions on this document.

## 1. Intent Specification

An Intent is a self-contained document that explains the user request in a markdown file that has one H1 header as the title, followed by some required and optional H2 headers sections.

**IMPORTANT: The intent document **MUST** strive to keep explanations brief, concise and straight to the point. Developers prefer communication that's as straightforward as possible. Start by the most important parts that need to be told, follow with some brief context, and only add details when it makes sense.**

### 1.1 Required H1 Header Title

* The title MUST be the first line of the file and be short and concise and include the type of Intent and the Domain it refers to. The format for the title is `<typeofintent> (domain-resource): intent`, e.g. `54 - Feature (wharehouses-stocks): Track items with low stock`. 
  - the type of intent may be a `feature`, an `enhancement`, a `bug`, or something else. It needs to be defined as a single word without spaces, use only letters, numbers, `:`,  `-` and `_`.

### 1.2 Required H2 Headers Sections

* **WHY** the user as asked to do something, the intention.
* **WHAT** the user wants to build, which can be provided by the user as event modelling images, using the Gherkin language or as plain text. The AI Coding assistant can also help the user and infer the WHAT from the WHY (the intention), by asking relevant questions, if needed.  
* **HOW** the step-by-step that the AI Coding Agent plans to follow to build WHAT the user requested, the tasks and sub-tasks.

### 1.3 Optional H2 Headers Sections

* **TARGET AUDIENCE** The target audience for the request when makes sense.
* **CONSTRAINS** If nay exist they must be listed and briefly explained in a concise way.
* **DESIGN DECISIONS** The key design decisions, their rationale and trade-offs.
* **ALTERNATIVES CONSIDERED** Other approaches that were considered and why they weren't chosen.
* **ARCHITECTURE** Architecture decisions, considerations and diagrams if applicable. By default the Domain Resource Action architecture pattern is used as per @ARCHITECTURE.md.
* **IMPLEMENTATION** Notes on expected implementation details, key decisions, the expected challenges, and their possible resolutions.
* **TECHNICAL DETAILS** Specific technical details and considerations. For example what packages to use, and why they were chosen over other alternatives.
* **CODE SNIPPETS AND EXAMPLES** Provide them when the problem is complex to guide and help the AI Code Agent to better resolve them as you whish.
* **CHALLENGES & SOLUTIONS** Challenges encountered during implementation and how they were resolved. This only makes sense to add after the Intent is implemented, and didn't went as planned.

## 2. Intent Persistence Protocol

Intents must be persisted on the `.intents/` directory at the root of the project. 

The `.intents/` directory will have the following status folders for the Intents:

1. **todo** - To persist all new Intents at the time of their creation.
2. **work-in-progress** - To persist all Intents that are being worked on.
3. **completed** - To persist all Intents with all tasks and sub-tasks completed.

### 2.1 Tracking the Last Created Intent

The `.intents/` directory **MUST** have a file with a suffix of `last_intent_created` and as the name the number of the last Intent created, thus following this format `number.last_intent_created`. For example: `54.last_intent_created`. When the next Intent is created the file **MUST** be git renamed with the number increased by one, therefore to `55.last_intent_created`. The first Intent added to `.intents/todo` is **REQUIRED** to start at number `1`, therefore the file will be `1.last_intent_created`. 


The file name for the Intent to be created **MUST** follow the format `<number>_<typeofintent_<domain-resource><intent-dashed>`, e.g. `54_feature_wharehouses-stocks_track-items-stock`. 

If they don't exist yet, create the `.intents/*` directory, its folders (`todo`, `work-in-progress` and `completed`) and the file `0_last_intent_created`, where the number `0` means that no Intent was yet created. Commit this changes to git before proceeding with whatever it needs to be done next.

## 3. Intent Creation Protocol

**CRITICAL:** To propose, create or update and save the Intent the guidelines defined in the @DEVELOPMENT_WORKFLOW.md **MUST** be followed, especially the ones for 1.2 Task Implementation Protocol and 1.3 Task Completion Protocol. 

1. Before proposing an Intent you must check the `.intents/todo` directory to see of one already exists to implement the user request. 
2. If no Intent is found then you **MUST** also check the `.intents/work-in-progress` status folder to see if one exists with tasks to be completed for the user request.
3. If an Intent is found in either of the status folders, then you **MUST** read it and see if needs to be updated to better align with the user request and the current project documentation guidelines. 
4. If the Intent needs to be updated then you **MUST** propose such changes to the user for approval and save it to the `.intents/work-in-progress` status folder. 
5. If the Intent is to be created then you **MUST** propose it as a code change for user approval and then you **MUST** save it to the `.intents/todo` status folder. 
6. After the Intent is created or updated and saved into the respective status folder it **MUST** be committed before proceeding with its implementation or anything else the user requests.


## 4. Intent Implementation Protocol

**CRITICAL:** The guidelines defined in the @DEVELOPMENT_WORKFLOW.md **MUST** be followed, especially the ones for 1.2 Task Implementation Protocol and 1.3 Task Completion Protocol. 

On top of this critical guidelines to be followed, the Intent **MUST** be kept in the correct status folder on the `.intents/` directory:

1. **todo** - The Intent **MUST** be moved to the `work-in-progress` status folder once work starts on it.
2. **work-in-progress** - The Intent **MUST** be moved to the `completed` status folder once all tasks and sub-tasks on it are finished, and before git committing the changes.
3. **completed** - Changes can only be committed after a `work-in-progress` Intent as been moved here.

**CRITICAL:** When an Intent is created/updated/moved in any of the status folders, with the the user approval, it **MUST** be committed before proceeding with its implementation or anything else the user requests.

## 5. Intent Example

See the @INTENT_EXAMPLE.md file to use as a reference when implementing Intents for users requests. In a real project this Intent example would be located at the root of the project on the `.intents/` folder, e.g., `./.intents/todo/54_feature_wharehouses-stocks_track-items-with-low-stock.md`.
