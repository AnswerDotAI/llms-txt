# Changes


## v2 (August 2026)

The original llms.txt proposal was published in September 2024, when the
idea that language models would routinely read websites was still
speculative. Since then the community has taken to the proposal far more
than I expected. Thousands of sites now publish an llms.txt file,
[documentation platforms generate one
automatically](https://www.mintlify.com/docs/ai/llmstxt), and coding
agents use them reliably. That shift is what this revision reflects.

Adoption brought requests, and the commonest was discoverability. Given
a page, how does an agent find its markdown version, or the llms.txt
file that covers it, without guessing? v2 answers with standard link
relations: `rel="alternate" type="text/markdown"` points to a page’s
markdown version, and `rel="describedby"` points to the llms.txt file
that covers it, provided as HTML `<link>` elements or an HTTP `Link:`
header.

Practice also diverged from v1 in ways worth blessing. v1 specified one
URL form for markdown versions, `.md` appended to the full page URL
(`page.html.md`). Some publishing tools instead replace the extension
(`page.md`), so v2 allows both. v1 permitted llms.txt files in subpaths
without saying what that meant. v2 defines it: a file covers the pages
under its path, and the most specific file applies. This is also what
lets a site that only controls a path, such as a GitHub Pages project
site, participate fully.

v1 said nothing about how llms.txt should be consumed, and described the
`llms_txt2ctx` tool for expanding a file into an LLM context. v2 instead
states the expectation directly: agents view or search the llms.txt to
find what they need, then follow the relevant links, which should point
to LLM-friendly content. The context-expansion tooling is no longer part
of the proposal, and with it goes the special meaning of the `Optional`
section, which told those tools what to omit. Optional sections are
still allowed, and remain a useful convention for secondary links, but
they no longer carry mechanical semantics. Finally, the background and
examples now describe how agents actually use websites, rather than
predicting that they might.
