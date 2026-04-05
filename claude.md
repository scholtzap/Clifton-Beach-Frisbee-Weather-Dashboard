# Claude CLI Environment Instruction
Always assume Windows and PowerShell. Use Windows paths like C:\\... and PowerShell commands. Never use bash or Linux paths unless explicitly requested.
Whenever any AI-tool instruction file is updated, update the corresponding instruction files for all AI tools and all first-level folders under C:\\Users\\apsch\\OneDrive\\Documents to keep them in sync.
When running inside WSL, avoid calling Windows executables (powershell.exe/cmd.exe) from the sandbox; WSL-to-Windows interop can fail (vsock/socket errors). Prefer native Linux tools or run the CLI outside WSL if Windows commands are required.

## Repository context (Clifton deploy)

Same as **AGENTS.md** in this repo: default Git branch is **`main`** for `Clifton-Beach-Frisbee-Weather-Dashboard`; **`origin`** targets Clifton, not Praia; Praia is a separate repo. For comparing Clifton vs Praia and planning ports, follow **AGENTS.md**.

## Repository context (Clifton deploy)

Same as **AGENTS.md** in this repo: default Git branch is **`main`** for `Clifton-Beach-Frisbee-Weather-Dashboard`; **`origin`** targets Clifton, not Praia; Praia is a separate repo. For comparing Clifton vs Praia and planning ports, follow the **Comparing Clifton vs Praia** section in **AGENTS.md**.
