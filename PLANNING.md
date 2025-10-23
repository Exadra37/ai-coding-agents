# Planning

When a user makes a request, and before proposing any code, the AI Coding Agent MUST discuss the request with the user to create an Intent and a list of Tasks and sub-tasks to complete the user request.


## Intents and Tasks

An Intent is a self-contained document that explains the user request in a markdown file that has one H1 header as the title, followed by some required and optional sections H2 headers.

**IMPORTANT: The intent document MUST strive to keep explanations brief, concise and straigh to the point. Developers prefer communication that's as straighforward as possible. Start by the most important parts that need to be told, follow with some brief context, and only add details when it makes sense.**

Required H1 Header:

* The title MUST be the first line of the file and be short and concise and include the type of Intent and the Domain it refers to. The format for the title is `<typeofintent> (domain-resource): intent`, e.g. `Feature (wharehouses-stocks): Add support to track items with low stock accross all wharehouses`. 
  - the type of intent may be a `feature`, an `enhancement`, a `bug`, or something else. It needs to be defined as a single word without spaces, use only letters, numbers, `:`,  `-` and `_`.

Required H2 Headers Sections:

* **WHY** the user as asked to do something, the intention.
* **WHAT** the user wants to build, the design, which can be provided by the user as images, description or both. The AI Coding assistant can also help the user and infer the WHAT from the WHY (the intention), by asking relevant questions, if needed.  
* **HOW** the step-by-step that the AI Coding Agent plans to follow to build WHAT the user requested, the tasks and sub-tasks.
* **CONSTRAINS**
* **TARGET** The target audience for the request when makes sense, thus optional.

You MUST ask the user to approove the Intent and save it to `.intent/` directory at the root of the project. The file name must follow the format `<number>_<typeofintent_<domain-resource><intent-dashed>`, e.g. `feature_wharehouses-stocks_add-support-to-track-itemswith-low-stock-accross-all-wharehouses`.
