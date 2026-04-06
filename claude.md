# Claude CLI Environment Instruction
Always assume Windows and PowerShell. Use Windows paths like C:\\... and PowerShell commands. Never use bash or Linux paths unless explicitly requested.
Whenever any AI-tool instruction file is updated, update the corresponding instruction files for all AI tools and all first-level folders under C:\\Users\\apsch\\OneDrive\\Documents to keep them in sync.
When running inside WSL, avoid calling Windows executables (powershell.exe/cmd.exe) from the sandbox; WSL-to-Windows interop can fail (vsock/socket errors). Prefer native Linux tools or run the CLI outside WSL if Windows commands are required.

## Repository context (this workspace only)

Applies only in **this** Beach / Clifton deploy folder: default branch **`main`**, **`origin`** = Clifton repo, Praia is separate. Full cross-repo comparison: use **`COMPARISON-AGENT-PROMPT.md`** with a new agent in a fresh directory. See **AGENTS.md** for workspace-scoped notes.
