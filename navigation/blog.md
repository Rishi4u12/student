---
layout: blogs          # Layout template for blog listing (theme specific)
title: Blogs           # Page title shown in browser and header
search_exclude: true   # Prevent indexing in site search
permalink: /blogs/     # Final URL -> /student/blogs/ (baseurl prefix added at build)
---

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>CSP Retrospective: Growth, Projects, and Next Steps</title>
  <style>
    :root {
      --bg: #0f172a;          /* slate-900 */
      --card: #111827;        /* gray-900 */
      --muted: #94a3b8;       /* slate-400 */
      --text: #e5e7eb;        /* gray-200 */
      --accent: #60a5fa;      /* blue-400 */
      --ring: #22d3ee;        /* cyan-400 */
    }
    html, body { height: 100%; }
    body {
      margin: 0; font: 16px/1.6 system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple Color Emoji", "Segoe UI Emoji";
      background: radial-gradient(1200px 800px at 80% -10%, rgba(96,165,250,0.15), transparent),
                  radial-gradient(900px 700px at -10% 20%, rgba(34,211,238,0.12), transparent),
                  var(--bg);
      color: var(--text);
    }
    .wrap { max-width: 900px; margin: 40px auto; padding: 0 20px; }
    .hero { display: grid; gap: 8px; margin-bottom: 24px; }
    .title { font-size: clamp(28px, 2.6vw + 16px, 40px); font-weight: 800; letter-spacing: 0.2px; }
    .subtitle { color: var(--muted); font-size: 15px; }

    .card { background: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));
            border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 22px 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.25); }

    details.section { border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 0; overflow: hidden; background: rgba(255,255,255,0.02); }
    details.section + details.section { margin-top: 14px; }
    summary { cursor: pointer; list-style: none; padding: 18px 18px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
    summary::-webkit-details-marker { display: none }
    .badge { font-size: 12px; padding: 2px 10px; border-radius: 999px; border: 1px solid rgba(255,255,255,0.1); color: var(--accent); background: rgba(96,165,250,0.08); }
    .content { padding: 0 18px 18px 18px; color: var(--text); }
    h3 { margin: 14px 0 8px; font-size: 18px; }
    p { margin: 8px 0; }
    ul { margin: 10px 0 10px 18px; }
    li { margin: 6px 0; }
    .muted { color: var(--muted); }

    .row { display: grid; grid-template-columns: 1fr; gap: 14px; }
    @media (min-width: 840px) {
      .row { grid-template-columns: 1fr 1fr; }
    }

    .footer { margin-top: 28px; color: var(--muted); font-size: 14px; }
    .pill { display:inline-flex; align-items:center; gap:8px; padding:6px 12px; border-radius:999px; border:1px solid rgba(255,255,255,0.1); background:rgba(255,255,255,0.03)}
    .kbd { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; font-size: 12px; padding: 2px 6px; border-radius: 6px; background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); }
    .score { font-weight: 800; color: var(--ring); }
    .btn { appearance: none; border: 1px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.06); color: var(--text); padding: 8px 12px; border-radius: 10px; cursor: pointer; }
    .btn:hover { border-color: rgba(255,255,255,0.25); }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="hero">
      <div class="pill">🧠 <span>CSP Retrospective</span> • <span class="muted">Growth, Projects, and Next Steps</span></div>
      <div class="title">Reflecting on My Semester</div>
      <div class="subtitle">A concise portfolio-ready write‑up generated with JavaScript and the DOM.</div>
    </div>

    <div id="app" class="row"></div>

    <div class="footer">
      Tip: Press <span class="kbd">E</span> to expand/collapse all sections. Edit the <span class="kbd">data</span> object in the source to personalize.
    </div>
  </div>

  <script>
    // ===== Editable data for your retrospective =====
    const data = {
      comparingMyself: `At the beginning of the year, I was still figuring things out, but now I’ve learned how to use <b>GitHub</b> and its features, created a <b>Kanban board</b> for the team, improved my <b>collaboration skills</b>, gotten comfortable <b>prompt engineering for coding</b>, enhanced my <b>web development</b> skills, and become confident using <b>build tools</b> like VS Code, Terminal, GitHub, and AI. These skills have helped me work more efficiently, stay organized, and collaborate better with my team.`,

      sprints: [
        { title: "Tools Sprint", body: `I learned how to manage my workflow through GitHub and version control. Publishing with GitHub Pages connected the tooling dots and boosted my confidence.` },
        { title: "Fundamentals of JavaScript/Python", body: `I practiced variables, loops, and conditionals and wrote my own functions. Debugging strengthened my logic and problem‑solving skills.` },
        { title: "West Coast Travel / Digital Famine", body: `I combined creativity with CS—using data visualization and design to tell meaningful stories with code.` },
      ],

      natm: `Presenting at N@tM was energizing. Visitors called out the <b>depth</b> of my project and were impressed by my <b>technical language</b> and clear explanations. Seeing people engaged with my work was incredibly rewarding.`,

      nextSteps: `Given more time, I would add <b>interactivity</b> and real‑time <b>data connections</b> (APIs, user input). I also want to polish the interface so it feels more professional and intuitive.`,

      learnNext: `Next, I want to dive deeper into <b>artificial intelligence, data analytics, and automation</b>. I’m curious about how models find patterns and how to combine strong front‑end design with back‑end logic for full‑stack apps.`,

      analytics: `My workflow improved steadily—fewer syntax hiccups, faster debugging, and better task organization. Most importantly, I now focus on <b>why</b> a solution works, not just how to code it.`,

      mcq: {
        score: 56,
        total: 66,
        strengths: ["data", "the Internet", "logic"],
        improvements: ["encryption", "algorithm comparisons", "logic gates", "encryption types", "algorithm efficiency"],
        approach: `I’m reviewing missed items carefully and slowing down during questions—parsing what’s being asked before choosing an answer.`
      },

      coolThing: `I built a <b>Connect 4</b> game that started as multiplayer, then implemented a <b>bot</b> so single players could practice against the computer. It taught me how to use logic, conditionals, and loops to simulate decision‑making, and how <b>abstraction</b> keeps the code clean and reusable.`,

      finalThoughts: `This semester took me from basics to confidently explaining and shipping projects. I strengthened teamwork, deepened my technical foundations, and grew a real passion for building. I’m proud of the progress—and excited for what’s next!`,
    };

    // ===== Rendering helpers =====
    const app = document.getElementById('app');

    function card(node) {
      const div = document.createElement('div');
      div.className = 'card';
      div.appendChild(node);
      return div;
    }

    function section(title, html, opts = {}) {
      const det = document.createElement('details');
      det.className = 'section';
      det.open = !!opts.open;

      const sum = document.createElement('summary');
      sum.innerHTML = `${opts.badge ? `<span class="badge">${opts.badge}</span>` : ''}${opts.badge ? '&nbsp;' : ''}${title}`;

      const content = document.createElement('div');
      content.className = 'content';
      content.innerHTML = html;

      det.append(sum, content);
      return det;
    }

    // ===== Compose sections =====
    const left = document.createElement('div');
    const right = document.createElement('div');

    left.append(
      section('🚀 Comparing Myself to the Beginning of the Year', `<p>${data.comparingMyself}</p>`, { open: true, badge: 'Growth' }),
      section('🧩 Sprint Highlights', `
        <h3>Highlights</h3>
        <ul>
          ${data.sprints.map(s => `<li><b>${s.title}:</b> ${s.body}</li>`).join('')}
        </ul>
      `, { badge: 'Sprints' }),
      section('🌟 N@tM Reflection', `<p>${data.natm}</p>`, { badge: 'Showcase' }),
    );

    right.append(
      section('🧩 Project Next Steps', `<p>${data.nextSteps}</p>`, { badge: 'Roadmap' }),
      section('💻 What I Want to Learn Next', `<p>${data.learnNext}</p>`, { badge: 'Learning' }),
      section('📊 Analytics Review', `<p>${data.analytics}</p>`, { badge: 'Analytics' }),
      section('🧮 MCQ Review', `
        <p>Score: <span class="score">${data.mcq.score}</span>/<b>${data.mcq.total}</b></p>
        <p><b>Strengths:</b> ${data.mcq.strengths.join(', ')}</p>
        <p><b>Focus Areas:</b> ${data.mcq.improvements.join(', ')}</p>
        <p>${data.mcq.approach}</p>
      `, { badge: 'MCQ' }),
      section('🔧 Something Cool to Share', `<p>${data.coolThing}</p>`, { badge: 'Project' }),
      section('🎉 Final Thoughts', `<p>${data.finalThoughts}</p>`, { badge: 'Wrap‑up' }),
    );

    app.append(card(left), card(right));

    // ===== UX niceties =====
    function setAll(open) {
      document.querySelectorAll('details.section').forEach(d => d.open = open);
    }

    let expanded = true;
    document.addEventListener('keydown', (e) => {
      if (e.key.toLowerCase() === 'e') {
        expanded = !expanded; setAll(expanded);
      }
    });

    // Add a quick export-to-markdown button (optional)
    const exportBtn = document.createElement('button');
    exportBtn.className = 'btn';
    exportBtn.textContent = 'Export as Markdown';
    exportBtn.addEventListener('click', () => {
      const md = [
        '# CSP Retrospective: Growth, Projects, and Next Steps',
        '\n## Comparing Myself to the Beginning of the Year', stripHtml(data.comparingMyself),
        '\n## Sprint Highlights', ...data.sprints.map(s => `- **${s.title}:** ${s.body}`),
        '\n## N@tM Reflection', stripHtml(data.natm),
        '\n## Project Next Steps', stripHtml(data.nextSteps),
        '\n## What I Want to Learn Next', stripHtml(data.learnNext),
        '\n## Analytics Review', stripHtml(data.analytics),
        `\n## MCQ Review`,
        `Score: ${data.mcq.score}/${data.mcq.total}`,
        `Strengths: ${data.mcq.strengths.join(', ')}`,
        `Focus Areas: ${data.mcq.improvements.join(', ')}`,
        data.mcq.approach,
        '\n## Something Cool to Share', stripHtml(data.coolThing),
        '\n## Final Thoughts', stripHtml(data.finalThoughts)
      ].join('\n\n');

      downloadText('csp-retrospective.md', md);
    });

    document.querySelector('.wrap').appendChild(exportBtn);

    function stripHtml(html) {
      const div = document.createElement('div');
      div.innerHTML = html; return div.textContent || div.innerText || '';
    }

    function downloadText(filename, text) {
      const blob = new Blob([text], { type: 'text/markdown;charset=utf-8' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url; a.download = filename; a.click();
      URL.revokeObjectURL(url);
    }
  </script>
</body>
</html>
