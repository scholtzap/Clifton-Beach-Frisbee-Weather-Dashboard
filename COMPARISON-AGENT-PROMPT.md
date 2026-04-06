# Prompt: compare Clifton vs Praia dashboard repos (hand this to a new agent)

Copy everything below the line into a new chat. Adjust `BASE` if you want a different parent folder.

---

You are working on **Windows with PowerShell**.

## Goal

Compare two public GitHub repos side by side and produce a **concise, actionable report** so a human can decide what to port between **Clifton** (canonical / newer patterns) and **Praia** (may have diverged).

## Repos

- **Clifton:** `https://github.com/scholtzap/Clifton-Beach-Frisbee-Weather-Dashboard.git` (default branch `main`)
- **Praia:** `https://github.com/scholtzap/Praia-da-Rocha-Beach-Ultimate-Weather-Dashboard.git` (use default branch)

## Setup (new folder only)

1. Create a dedicated parent directory, e.g. `BASE = C:\temp\dashboard-compare-<DATE>` (pick a fresh path; do not reuse an existing project clone).
2. Clone both repos into sibling folders:

   ```powershell
   $BASE = "C:\temp\dashboard-compare-$(Get-Date -Format 'yyyyMMdd-HHmm')"
   New-Item -ItemType Directory -Path $BASE -Force | Out-Null
   Set-Location $BASE
   git clone https://github.com/scholtzap/Clifton-Beach-Frisbee-Weather-Dashboard.git clifton
   git clone https://github.com/scholtzap/Praia-da-Rocha-Beach-Ultimate-Weather-Dashboard.git praia
   ```

3. Record the **short commit hash** of each `HEAD` in the report.

## Files to compare (minimum)

For each path below, if the file exists in **both** clones, diff it; if it exists in only one, note **Clifton-only** or **Praia-only**.

| Path | Why |
|------|-----|
| `config.yml` | Location-specific settings |
| `script.js` | Client behavior |
| `style.css` | Layout / theme |
| `package.json` | Dependencies / scripts |
| `index.html` | Often generated — note if one is hand-edited vs build output |
| `scripts\` (all) | Data fetch / build pipeline |
| `.github\workflows\` (all) | CI behavior |

Use:

```powershell
git diff --no-index "$BASE\clifton\<path>" "$BASE\praia\<path>"
```

For directories, either summarize file lists (`Get-ChildItem -Recurse -File`) and diff matching filenames, or use a folder diff tool if available.

## Report structure (required)

Deliver **Markdown** with these sections:

1. **Executive summary** (5–10 lines): Are they substantially aligned, or forked? Biggest risks if Praia is left as-is?
2. **Inventory table:** each compared path → status: **identical**, **minor diff**, **major diff**, **Clifton-only**, **Praia-only**.
3. **Notable diffs:** bullet list of the **top 10** behavioral or security-relevant differences (e.g. API keys in HTML, missing workflows, outdated `populartimes` usage).
4. **Recommendations** grouped as:
   - **Port Praia → align with Clifton** (ordered by impact / effort)
   - **Keep Praia-specific** (intentional differences)
   - **Optional / later**
5. **Commands run:** list the exact `git` / PowerShell commands you used (for reproducibility).

## Constraints

- Do **not** commit secrets; redact any keys if they appear in diffs.
- Do **not** push changes unless the user explicitly asks; this task is **read-only comparison** unless they say otherwise.
- Prefer **evidence** (short diff excerpts or line counts) over speculation.

## Done when

The human can answer: “What should we copy to Praia next, and what should stay different?” without opening both repos manually.
