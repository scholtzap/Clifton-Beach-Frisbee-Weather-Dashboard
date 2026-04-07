# Clifton vs Praia dashboard repos — comparison report

**Clifton** `HEAD`: `b90fdbf` (default branch `main`)  
**Praia** `HEAD`: `002bed2` (default branch)  
**Compared from fresh clones under:** `C:\Users\apsch\Documents\beach-ultimate-weather-dashboard\comparison\`

---

## 1. Executive summary

The two repositories are **largely the same product**: shared `config.yml` (both locations defined), identical `script.js`, `style.css`, and `package.json`, and the same core data scripts except **`scripts/build-html.js`**. They are **not** arbitrary forks; differences are mostly **location-specific HTML output**, **CI layout**, and **how the YouTube Data API key is handled**.

The **highest-impact gap** is **secrets hygiene**: Praia’s `build-html.js` **hardcodes a browser YouTube API key** in source, while Clifton’s version **requires `YOUTUBE_API_KEY` from the environment** and fails the build if it is missing when `youtube_search` is enabled. Separately, **Clifton’s committed `index.html` still contains an inline `window.YOUTUBE_API_KEY`** (visible in the diff), which is a **credential-in-repo** risk for whichever key that is.

**CI:** Clifton adds **`.github/workflows/push-pipeline.yml`**, a single **push** workflow that installs Node + Python, runs `build-html`, fetches weather/tides/busyness, and commits **HTML + all JSON data** in one shot. Praia **does not** have this workflow; it relies on the existing scheduled/dispatch workflows only.

If Praia is left as-is: **YouTube key rotation and abuse surface** are harder to manage; **no unified push pipeline** means post-merge refresh behavior may diverge from Clifton; **Praia’s `update-data.yml` omits `YOUTUBE_API_KEY`**, which is fine for `LOCATION=praia` today (no `youtube_search` in config) but is fragile if someone enables search for Praia without restoring secret injection.

---

## 2. Inventory table

| Path | Status | Notes |
|------|--------|--------|
| `config.yml` | **identical** | Single file; both `clifton` and `praia` blocks present in each clone. |
| `script.js` | **identical** | |
| `style.css` | **identical** | |
| `package.json` | **identical** | |
| `index.html` | **major diff** | Titles, embeds, share links, WhatsApp block, YouTube search script (Clifton has inline API key in committed file). |
| `scripts/` (all) | **minor diff** | Only `build-html.js` differs; `fetch-weather.js`, `fetch-tides.js`, `fetch-busyness.py` identical. |
| `.github/workflows/` | **major diff** | `push-pipeline.yml` **Clifton-only**; `update-data.yml` / `fetch-busyness.yml` small env/comment diffs; `fetch-tides.yml` identical. |

---

## 3. Notable diffs (top 10)

1. **`scripts/build-html.js` — YouTube API key sourcing:** Clifton reads **`process.env.YOUTUBE_API_KEY`** and **`process.exit(1)`** if missing when `loc.youtube_search.enabled`; Praia **embeds a hardcoded** `window.YOUTUBE_API_KEY = "AIza…"` string (full value redacted here). **Security / ops:** prefer Clifton’s pattern everywhere.
2. **Committed `index.html` — inline secret (Clifton):** Diff shows Clifton’s `index.html` includes **`window.YOUTUBE_API_KEY = "<key>"`** in a `<script>` block. **Treat as exposed**; rotate if ever committed publicly, and regenerate from CI with env injection only.
3. **Praia `index.html` — extra embeds:** Windy webcam block + **beachcam.meo.pt** CTA; Windy map **lat/lon** and YouTube **live channel** match Praia’s `config.yml` expectations.
4. **Clifton `index.html` — WhatsApp CTA:** Present; Praia removes it because **`whatsapp_form: null`** for Praia in shared `config.yml` (expected).
5. **`.github/workflows/push-pipeline.yml`:** **Clifton-only** — on `push` to `main`, runs full pipeline (Node build HTML, weather, tides, Python populartimes, busyness) and commits `index.html` + `data/*.json`.
6. **`.github/workflows/update-data.yml`:** Praia drops **`YOUTUBE_API_KEY: ${{ secrets.YOUTUBE_API_KEY }}`** from `env`. Harmless for Praia while `youtube_search` is unset for that location; **required** if Praia ever enables YouTube search like Clifton.
7. **`.github/workflows/fetch-busyness.yml`:** Praia adds **`GOOGLE_PLACE_ID: ${{ secrets.GOOGLE_PLACE_ID }}`** to `env`; Clifton omits that line (script still supports override via env — same Python in both). Comment-only difference on the Places key note.
8. **`fetch-busyness.py`:** **Identical** in both clones; uses `populartimes.get_id`, `GOOGLE_API_KEY`, and `GOOGLE_PLACE_ID` or `config.yml` `google_place_id`.
9. **Share URLs / branding:** Twitter, Facebook, LinkedIn links point at each repo’s **GitHub Pages** path — aligned with `github_repo` per location in `config.yml`.
10. **`build-html.js` Windy webcam label:** Hardcoded text **“Portimão: Praia da Rocha – Windy Webcam”** inside the generator — fine for Praia but **not location-agnostic** if reused for other sites without templating.

---

## 4. Recommendations

### Port Praia → align with Clifton (impact / effort)

1. **Replace Praia’s `scripts/build-html.js` YouTube block with Clifton’s env-based implementation** (high impact, low effort). Keeps keys out of git and matches CI secrets model.
2. **Add `push-pipeline.yml` to Praia** (or equivalent) if you want **the same “every push refreshes HTML + all data”** behavior as Clifton (medium effort; verify Praia secrets: `OWM`, `STORMGLASS`, `GOOGLE`, optional `YOUTUBE`).
3. **If Praia enables `youtube_search` in `config.yml` later**, restore **`YOUTUBE_API_KEY`** in **`update-data.yml`** (and any workflow that runs `build-html.js` with that feature on) — low effort, prevents silent build/runtime failure.
4. **Regenerate and commit Clifton `index.html` without embedded API key** (high security impact): run `build-html.js` with secret from CI only; ensure no key in static HTML in either repo going forward.

### Keep Praia-specific (intentional)

- **Windy webcam + beachcam button** and **Praia coordinates / channel IDs** in generated HTML (driven by `config.yml` / `additional_embeds` / `beachcam_url`).
- **No WhatsApp section** for Praia (`whatsapp_form: null`).
- **`GOOGLE_PLACE_ID` in `fetch-busyness.yml` env** on Praia if you rely on that secret to override config (optional; config already has place id).

### Optional / later

- **Templatize** Windy webcam link text in `build-html.js` to use `loc.name` instead of a fixed “Portimão…” string for multi-location reuse.
- **Document** in each repo’s README which workflows exist and which secrets/vars are required for `LOCATION`.

---

## 5. Commands run (reproducibility)

```powershell
$BASE = "C:\Users\apsch\Documents\beach-ultimate-weather-dashboard\comparison"
New-Item -ItemType Directory -Path $BASE -Force | Out-Null
Set-Location $BASE
git clone https://github.com/scholtzap/Clifton-Beach-Frisbee-Weather-Dashboard.git clifton
git clone https://github.com/scholtzap/Praia-da-Rocha-Beach-Ultimate-Weather-Dashboard.git praia

Push-Location clifton
git rev-parse --short HEAD
Pop-Location
Push-Location praia
git rev-parse --short HEAD
Pop-Location
```

Per-file comparison (examples):

```powershell
git diff --no-index --stat "$BASE\clifton\config.yml" "$BASE\praia\config.yml"
git diff --no-index --stat "$BASE\clifton\script.js" "$BASE\praia\script.js"
git diff --no-index --stat "$BASE\clifton\style.css" "$BASE\praia\style.css"
git diff --no-index --stat "$BASE\clifton\package.json" "$BASE\praia\package.json"
git diff --no-index --stat "$BASE\clifton\index.html" "$BASE\praia\index.html"

git diff --no-index --stat "$BASE\clifton\scripts\fetch-weather.js" "$BASE\praia\scripts\fetch-weather.js"
git diff --no-index --stat "$BASE\clifton\scripts\build-html.js" "$BASE\praia\scripts\build-html.js"
git diff --no-index --stat "$BASE\clifton\scripts\fetch-busyness.py" "$BASE\praia\scripts\fetch-busyness.py"
git diff --no-index --stat "$BASE\clifton\scripts\fetch-tides.js" "$BASE\praia\scripts\fetch-tides.js"

git diff --no-index --stat "$BASE\clifton\.github\workflows\update-data.yml" "$BASE\praia\.github\workflows\update-data.yml"
git diff --no-index --stat "$BASE\clifton\.github\workflows\fetch-tides.yml" "$BASE\praia\.github\workflows\fetch-tides.yml"
git diff --no-index --stat "$BASE\clifton\.github\workflows\fetch-busyness.yml" "$BASE\praia\.github\workflows\fetch-busyness.yml"
```

Clifton-only workflow (no counterpart path in Praia):

```powershell
Test-Path "$BASE\praia\.github\workflows\push-pipeline.yml"   # False
Get-Content "$BASE\clifton\.github\workflows\push-pipeline.yml"
```

---

## Redaction note

Any **Google / YouTube API key material** observed in diffs was **redacted** in this report. **Rotate** keys that have appeared in public git history or static HTML.

---

## Post-alignment (Clifton source workspace, 2026-04-07)

Executed items in the canonical **Clifton** working copy (`beach-ultimate-weather-dashboard`):

- `scripts/build-html.js`: **Requires `YOUTUBE_API_KEY` in CI** when `youtube_search` is on; **allows an empty key locally** so committed `index.html` can omit secrets (YouTube search falls back to the default channel URL per `script.js`).
- Regenerated **`index.html`** without an embedded `AIza…` key (empty `window.YOUTUBE_API_KEY`).
- **Windy webcam** link text: driven by optional `additional_embeds[].label` or `${loc.name} – Windy Webcam`.
- **`deploy-all.sh`**: `MAIN_DIR` defaults to the script’s directory; override with `MAIN_DIR=...` if needed.
- **`deploy-all.ps1`** + **Windows** subsection in **`MULTI-REPO-WORKFLOW.md`** for PowerShell deploys.
- **`.gitignore`**: `comparison/clifton/` and `comparison/praia/` for local clone diffs.

**Still manual for the Praia GitHub repo:** copy aligned files (especially `scripts/build-html.js`, `.github/workflows/push-pipeline.yml` if desired, and `update-data.yml` with `YOUTUBE_API_KEY` in `env` if Praia ever enables `youtube_search`), set `vars.LOCATION=praia`, and push.
