---
layout: blogs 
title: Blogs
search_exclude: true
permalink: /blogs/
---

# My CSP Setup Journey

Welcome to my Blogs page. 

## 🖥️ Getting VS Code Ready
Installed VS Code (enabled PATH + context menu options) and verified tooling:

```bash
python --version
git --version
```

Configured global Git identity (name & email) so commits sync properly.

## 📂 Repositories & Structure
Cloned personal, pages, and team repositories. Forked the team repo for safe experimentation before contributing back via pull requests.

## 🐍 Virtual Environment
Created an isolated Python environment:

```bash
./scripts/venv.sh
source venv/bin/activate
```

This kept dependencies consistent across notebooks and scripts.

## 🤝 Collaboration Workflow
Practiced branching, syncing upstream, and resolving merge conflicts. Keeping the fork updated reduced friction during reviews.

## 📓 Jupyter Notebooks
Ran and committed notebooks with outputs preserved so they render correctly on GitHub Pages. Experimented with adding custom content (like jokes) to verify formatting.

## ✅ Accomplishments (Snapshot)
- Verified Python + VS Code toolchain
- Managed multiple repos (clone, fork, pull, merge)
- Established virtual environment discipline
- Ensured notebooks render with outputs
- Improved Git workflow confidence

## 🌟 Reflection
Early repetition (and a few retries) built troubleshooting habits. Peer help accelerated learning and confidence working across different environments.

## 📅 Weeks 1–4 Summary
| Area | Highlights |
|------|-----------|
| About Page | Built initial personal profile page |
| Repo Management | Cloned & organized multiple repositories |
| File Movement | Copied lesson notebooks (eg. background lesson) |
| Notebook Practice | Ran & exported Jupyter notebooks |
| Visual Tweaks | Edited background and layout elements |

---
_Last updated: {{ site.time | date: '%Y-%m-%d' }}_