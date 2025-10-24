# AI Coding Agents

This project will be a collection of files to guide and instruct AI Coding Agents (Claude, Gemini, Cursor, CoPilot, etc.) to assist developers coding applications that run on the BEAM, when using Elixir, Erlang and Gleam programming languages and their main frameworks.

## How to Use

You **MUST** start a new session with your AI Coding agent, assistant, LLM When adding this collection of guidelines to your project, otherwise the current context on it may interfere.


### First Two Prompts to use on All AI Sessions

To ensure that the AI is on the same page as you we strongly recommend to execute the below prompts. If you are worried about tokens usage, then at least execute the second prompt.

First, start by instructing the AI to read the Agents file:

```
Read the @AGENTS.md in full and also read in full all the documents it links to, and do the same for links included in any of this files. 
Make sure you understand every bit on them, otherwise we will waste our time when working together, because we will not have the same understanding of whats in the documentation.
```

After the AI says it has read it, ensure it as understood everything:

```
Do you have questions about the documentation? Any thing that's not clear to you? Don't make assumptions.
```

> **TIP:** If the AI Coding Agent hallucinates after one of this prompts, specially when it answers the second prompt, where it may be a lot off and misunderstands the documents it was asked to read and grasp, then it's better that you start another session.
