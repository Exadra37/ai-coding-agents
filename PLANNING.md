# Planning

**IMPORTANT:** Before proposing or writing any application or test code, everything done in this project **MUST** be planned by following an **Intent Driven Development (IDD)** approach, detailed in the INTENT_SPECIFICATION.md, with an **Incremental Generation Workflow** based on **User Approval** as per detailed instructions on the DEVELOPMENT_WORKFLOW.md.


## 1. On First Use

1.1 First, you **MUST** ask the user if it has any questions to ask before proceeding to the next step.

1.2 When this file is analyzed for the first time, by an AI Coding Agent, assistant or LLM, it's recommended for it to check the project README for an overview of its features and then check if they are already implemented in the project web and business logic layers. 

1.3 Then ask the user if he wants to proceed with a brainstorm session to discuss and create one Intent per feature not implemented yet, with tasks and sub-tasks. The Intent **MUST** follow the INTENT_SPECIFICATION.md and the INTENT_EXAMPLE.md format. 

1.4 If the check of the project code doesn't yield conclusive results about which features are implemented and missing then ask the user, instead of making assumptions and guessing. 

 
## 2. User Request

2.1 When a user makes a request, and before proposing any code, the AI Coding Agent, assistant or LLM **MUST** understand the user request and discuss it with the user if it has doubts or needs clarifications.

2.2 Now that the user request is clearly understood it's time to propose an Intent, for user approval as a code change, with a list of Tasks and sub-tasks to complete the user request. The Intent **MUST** follow the INTENT_SPECIFICATION.md and the INTENT_EXAMPLE.md format.

2.3 After the Intent is created, as per the Intent specification and example, it's time to ask the user if he wants to continue planning more work on the project or wants to proceed with the implementation of an Intent.
