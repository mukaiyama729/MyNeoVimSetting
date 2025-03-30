*Avante*

設定に関して

**gemini**

```lua
  opts = {
    -- add any opts here
    -- for example
    provider = "gemini",
    auto_suggestions_provider = "gemini",

    gemini = {
      endpoint = "https://generativelanguage.googleapis.com",
      model = "gemini-2.0-pro-exp-02-05", -- your desired model (or use gpt-4o, etc.)
      timeout = 50000,                 -- timeout in milliseconds
      temperature = 0,                 -- adjust if needed
      max_tokens = 4096,
      -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
    },
```

APIKEYは環境変数で指定することを推奨します
GOOGLE_API_KEY
**openai**

```lua
  opts = {
    -- add any opts here
    -- for example
    provider = "openai",
    auto_suggestions_provider = "openai",

    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4o-mini", -- your desired model (or use gpt-4o, etc.)
      timeout = 50000,    -- timeout in milliseconds
      temperature = 0,    -- adjust if needed
      max_tokens = 4096,
      -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
    },
```
OPENAI_API_KEY
