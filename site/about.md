---
layout: default
title: About
permalink: /about/
description: "Who Abhishek Dadhich is, why this blog exists, and how to get in touch. Résumé and experience on the resume page."
---

<div class="about-page">
  <h1>About</h1>

  <div class="about-intro">
    <p class="lead">
      I'm a cloud, platform, and security architect with twenty years of experience designing and evolving large-scale, business-critical systems.
    </p>

    <p>
      I write here about agentic AI from the perspective of someone who has spent two decades building the kind of platforms these agents are now starting to run inside. Most of the current writing on agentic AI comes from researchers and app developers. Both are valuable. Neither is the lens I bring.
    </p>

    <p>
      My current focus is <a href="https://github.com/aaif-goose/goose">Goose</a>, the open-source agent now hosted by the <a href="https://aaif.io">Agentic AI Foundation</a> at the Linux Foundation. Goose is local, has real shell access, and uses MCP to talk to anything. That makes it a fundamentally different category of tool from a coding assistant — and the platform engineering, DevSecOps, and supply chain questions it raises are mostly unwritten.
    </p>

    <p>
      For employment history, skills, and a PDF download, see the <a href="{{ '/resume/' | relative_url }}">résumé</a>. Recent posts are on the <a href="{{ '/blog/' | relative_url }}">blog</a>.
    </p>
  </div>

  <div class="about-full">
    <h2>What I write about</h2>
    <ul>
      <li><strong>Agentic AI in real platform environments</strong> — not "build a chatbot" but how Goose fits into an Internal Developer Platform, with what guardrails.</li>
      <li><strong>Software supply chain for agentic AI</strong> — provenance, attestation, SBOMs, and signing for MCP servers and agent workflows.</li>
      <li><strong>Zero-trust patterns for local agents</strong> — workload identity, least-privilege tool scoping, IAM models that make agents safe to run alongside production systems.</li>
      <li><strong>Honest writeups</strong> — including the parts where the agent was wrong and the parts where I had to override it.</li>
    </ul>

    <h2>Find me</h2>
    <ul>
      <li>LinkedIn: <a href="https://linkedin.com/in/{{ site.linkedin_username }}">{{ site.linkedin_username }}</a></li>
      <li>GitHub: <a href="https://github.com/{{ site.github_username }}">@{{ site.github_username }}</a></li>
      <li>AAIF Discord: I'm <code>@{{ site.github_username }}</code> in <a href="https://discord.com/invite/9zTwngHAMy">the AAIF Discord</a>, mostly in the #goose channel</li>
      <li>Email: <a href="mailto:{{ site.email }}">{{ site.email }}</a></li>
    </ul>

    <p>If you're working on Goose, thinking about supply chain security for agents, or building platforms that will eventually host this kind of workload — please reach out.</p>

    <h2>Colophon</h2>
    <p>
      Built with Jekyll, hosted on GitHub Pages, set in Fraunces and Inter Tight. Source on <a href="https://github.com/{{ site.github_username }}/{{ site.github_username }}.github.io">GitHub</a>.
    </p>
  </div>

</div>
