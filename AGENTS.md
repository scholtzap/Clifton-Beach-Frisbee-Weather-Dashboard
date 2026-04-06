# Codex Environment Instruction

Always assume Windows and PowerShell. Use Windows paths like C:\\... and PowerShell commands. Never use bash or Linux paths unless explicitly requested.

Whenever any AI-tool instruction file is updated, update the corresponding instruction files for all AI tools and all first-level folders under C:\\Users\\apsch\\OneDrive\\Documents to keep them in sync.

When running inside WSL, avoid calling Windows executables (powershell.exe/cmd.exe) from the sandbox; WSL-to-Windows interop can fail (vsock/socket errors). Prefer native Linux tools or run the CLI outside WSL if Windows commands are required.

---

**Workspace-only (do not generalize to other repos):** Everything from *Repository context* through *Comparing Clifton vs Praia* below applies **only** when working in **this** project folder (Beach Ultimate / Clifton deploy workspace). Ignore those bullets for unrelated codebases.

## Repository context (Clifton deploy)

- **GitHub:** [scholtzap/Clifton-Beach-Frisbee-Weather-Dashboard](https://github.com/scholtzap/Clifton-Beach-Frisbee-Weather-Dashboard). **Default branch is `main`**.
- **Use `main`** for ongoing work, PRs, and pushes. CI (**Push pipeline — build and refresh data**) runs on push to **`main`**.
- **`origin`** in this workspace is expected to point at the **Clifton** Pages deploy repo, not Praia.

## Praia deploy (separate)

- **GitHub:** [scholtzap/Praia-da-Rocha-Beach-Ultimate-Weather-Dashboard](https://github.com/scholtzap/Praia-da-Rocha-Beach-Ultimate-Weather-Dashboard). Treated as **divergent** from Clifton; do not assume file parity or shared CI without checking.

## Comparing Clifton vs Praia (for planning)

For a **full comparison run**, hand a new agent the prompt in **`COMPARISON-AGENT-PROMPT.md`** (fresh folder, structured report).

Quick local checks:

1. **Two fresh clones** (adjust paths as you like):

   ```powershell
   git clone https://github.com/scholtzap/Clifton-Beach-Frisbee-Weather-Dashboard.git C:\temp\dash-clifton
   git clone https://github.com/scholtzap/Praia-da-Rocha-Beach-Ultimate-Weather-Dashboard.git C:\temp\dash-praia
   ```

2. **Diff high-value shared files** (repeat per file):

   ```powershell
   git diff --no-index C:\temp\dash-clifton\script.js C:\temp\dash-praia\script.js
   git diff --no-index C:\temp\dash-clifton\style.css C:\temp\dash-praia\style.css
   git diff --no-index C:\temp\dash-clifton\config.yml C:\temp\dash-praia\config.yml
   ```

3. **Classify changes** before porting: **shared** (both sites), **Clifton-only**, **Praia-only**. Prefer driving differences through **`config.yml`** + repo **`LOCATION`** variable rather than forked logic.
