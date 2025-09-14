---
layout: blogs          # Layout template for blog listing (theme specific)
title: Blogs           # Page title shown in browser and header
search_exclude: true   # Prevent indexing in site search
permalink: /blogs/     # Final URL -> /student/blogs/ (baseurl prefix added at build)
---

<!--
Purpose: Static (non-animated) summary of CSP setup journey.
Editing notes:
- Keep fenced code blocks for commands.
- Table summarises first 4 weeks; extend by adding rows.
- Last updated line auto-refreshes each build via site.time.
-->

# My CSP Setup Journey

<!-- Intro section -->
Welcome to my Blogs page. This is a clean, static (non‑animated) write‑up of my early CSP setup and progress.

## 🖥️ Getting VS Code Ready
<!-- Verifying core developer tools -->
Installed VS Code (enabled PATH + context menu options) and verified tooling:

```bash
python --version
git --version
```

Configured global Git identity (name & email) so commits sync properly.

## 📂 Repositories & Structure
<!-- Repository strategy: clone + fork workflow -->
Cloned personal, pages, and team repositories. Forked the team repo for safe experimentation before contributing back via pull requests.

## 🐍 Virtual Environment
<!-- Isolated environment ensures reproducible dependencies -->
Created an isolated Python environment:

```bash
./scripts/venv.sh
source venv/bin/activate
```

This kept dependencies consistent across notebooks and scripts.

## 🤝 Collaboration Workflow
<!-- Git hygiene and upstream sync habits -->
Practiced branching, syncing upstream, and resolving merge conflicts. Keeping the fork updated reduced friction during reviews.

## 📓 Jupyter Notebooks
<!-- Notebook execution & commit policy -->
Ran and committed notebooks with outputs preserved so they render correctly on GitHub Pages. Experimented with adding custom content (like jokes) to verify formatting.

## ✅ Accomplishments (Snapshot)
<!-- Quick bullet list of key achievements -->
- Verified Python + VS Code toolchain
- Managed multiple repos (clone, fork, pull, merge)
- Established virtual environment discipline
- Ensured notebooks render with outputs
- Improved Git workflow confidence

## 🌟 Reflection
<!-- Personal learning reflection -->
Early repetition (and a few retries) built troubleshooting habits. Peer help accelerated learning and confidence working across different environments.

## 📅 Weeks 1–4 Summary
<!-- Progress overview table -->
| Area | Highlights |
|------|-----------|
| About Page | Built initial personal profile page |
| Repo Management | Cloned & organized multiple repositories |
| File Movement | Copied lesson notebooks (eg. background lesson) |
| Notebook Practice | Ran & exported Jupyter notebooks |
| Visual Tweaks | Edited background and layout elements |

---
<!-- Auto-updated timestamp; replace with a fixed date if you need permanence -->
_Last updated: {{ site.time | date: '%Y-%m-%d' }}_