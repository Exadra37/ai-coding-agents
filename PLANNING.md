# Planning

When a user makes a request, and before proposing any code, the AI Coding Agent MUST discuss the request with the user to create an Intent and a list of Tasks and sub-tasks to complete the user request.

## Intents and Tasks

An Intent is a self-contained document that explains the user request in a markdown file that has one H1 header as the title, followed by some required and optional H2 headers sections.

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

See the @INTENT_EXAMPLE.md file to use as a reference when implementing Intents for users requests. In a real project this Intent example would be located at the root of the project on the `.intents` folder, e.g., `./.intents/54_feature_wharehouses-stocks_track-items-with-low-stock.md`.
