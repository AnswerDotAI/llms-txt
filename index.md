# The /llms.txt file, v2
Jeremy Howard
2024-09-03

## Background

Agents now use websites constantly: a coding agent fetches a library’s
documentation to get an API call right, and a chat assistant with search
reads pages to answer questions about a product. When this proposal was
first written in 2024, this was largely a prediction. Today it is
routine.

But web pages are built for people. An HTML page wraps its information
in navigation, ads, and JavaScript, and converting it back into clean
text is difficult and imprecise. Context windows, while larger than they
were, are still too small for most websites in their entirety, and every
wasted token costs time and money. Agents are best served by concise,
expert-level information gathered in a single, accessible location.

This is v2 of the proposal, updated based on what I learned from two
years of adoption: thousands of sites publish an llms.txt file,
[documentation platforms generate one
automatically](https://www.mintlify.com/docs/ai/llmstxt), and Chrome’s
Lighthouse [audits sites for
one](https://developer.chrome.com/docs/lighthouse/agentic-browsing/llms-txt)
as part of its agentic browsing checks. The AI labs themselves publish
llms.txt files for their own developer docs:
[OpenAI](https://developers.openai.com/llms.txt),
[Anthropic](https://docs.anthropic.com/llms.txt), and
[Gemini](https://ai.google.dev/gemini-api/docs/llms.txt). The
[Changes](changes.qmd) page describes what changed since v1, and why.

## Proposal

<figure>
<img src="logo.png" class="lightbox floatr" width="150"
alt="llms.txt logo" />
<figcaption aria-hidden="true">llms.txt logo</figcaption>
</figure>

We propose adding a `/llms.txt` markdown file to websites to provide
LLM-friendly content. The file can be placed at the site root, or at any
path within it, covering the pages under that path. This file offers
brief background information, guidance, and links to detailed markdown
files.

llms.txt markdown is human and LLM readable, but is also in a precise
format allowing fixed processing methods (i.e. classical programming
techniques such as parsers and regex).

We furthermore propose that pages with information that agents might
need provide a clean markdown version of those pages at the same URL as
the original page, either with `.md` appended (`page.html.md`) or with
the extension replaced by `.md` (`page.md`). (URLs without file names
should append `index.html.md` or `index.md` instead.)

To help clients find these files, we recommend using standard link
relations: `rel="alternate" type="text/markdown"` points to the markdown
version of a page, and `rel="describedby"` points to the llms.txt file
that covers it. (An llms.txt file describes all pages under its path, so
`/docs/llms.txt` covers everything in `/docs/`.) These links can be
provided as HTML `<link>` elements, or as an HTTP `Link:` response
header. The header form also works for non-HTML resources, such as the
markdown files themselves, and can be added in web server or CDN
configuration without modifying any pages. For example:

    Link: </docs/page.html.md>; rel="alternate"; type="text/markdown", </docs/llms.txt>; rel="describedby"

The [FastHTML project](https://fastht.ml) follows these two proposals
for its documentation. For instance, here is the [FastHTML docs
llms.txt](https://www.fastht.ml/docs/llms.txt), placed at `/docs/` to
cover just the documentation pages. And here is an example of a [regular
HTML docs page](https://www.fastht.ml/docs/tutorials/by_example.html),
along with exact same URL but with [a .md
extension](https://www.fastht.ml/docs/tutorials/by_example.html.md).

Agents are expected to view or search `llms.txt` to find the information
they need, then follow the relevant links. The links in an llms.txt file
should therefore point to LLM-friendly content, such as the markdown
versions of pages described above. The file itself stays small enough to
fit in context. The detail lives behind the links, and is fetched only
when needed.

llms.txt files are used most heavily for software documentation, where
coding agents follow them to find API references and tutorials. The same
structure works anywhere agents need a guided path into a site’s
content: a business outlining its structure and policies, a personal
site answering questions about someone’s CV, or a school providing
access to course information.

Note that all [nbdev](https://nbdev.fast.ai/) projects now create .md
versions of all pages by default. All Answer.AI and fast.ai software
projects using nbdev have had their docs regenerated with this feature.
For an example, see the [markdown
version](https://fastcore.fast.ai/docments.html.md) of [fastcore’s
docments module](https://fastcore.fast.ai/docments.html).

## Format

At the moment the most widely and easily understood format for language
models is Markdown. Simply showing where key Markdown files can be found
is a great first step. Providing some basic structure helps a language
model to find where the information it needs can come from.

The `llms.txt` file is unusual in that it uses Markdown to structure the
information rather than a classic structured format such as XML. The
reason for this is that we expect many of these files to be read by
language models and agents. Having said that, the information in
llms.txt follows a specific format and can be read using standard
programmatic-based tools.

The llms.txt file spec is for files named `llms.txt`, at the root path
`/llms.txt` of a website or at any subpath (e.g. `/docs/llms.txt`). A
file covers the URLs under its path, and where more than one file
applies, agents should use the most specific one. A file following the
spec contains the following sections as markdown, in the specific order:

- An optional byte-order mark (BOM)
- An H1 with the name of the project or site. This is the only required
  section
- A blockquote with a short summary of the project, containing key
  information necessary for understanding the rest of the file
- Zero or more markdown sections (e.g. paragraphs, lists, etc) of any
  type except headings, containing more detailed information about the
  project and how to interpret the provided files
- Zero or more markdown sections delimited by H2 headers, containing
  “file lists” of URLs where further detail is available
  - Each “file list” is a markdown list, containing a required markdown
    hyperlink `[name](url)`, then optionally a `:` and notes about the
    file.

Here is a mock example:

``` markdown
# Title

> Optional description goes here

Optional details go here

## Section name

- [Link title](https://link_url): Optional link details

## Optional

- [Link title](https://link_url)
```

The “Optional” section is used, by convention, for secondary
information: links an agent can skip when a shorter context is needed.

## Existing standards

llms.txt is designed to coexist with current web standards. While
sitemaps list all pages for search engines, `llms.txt` offers a curated
overview for LLMs. It can complement robots.txt by providing context for
allowed content. The file can also reference structured data markup used
on the site, helping LLMs understand how to interpret this information
in context.

The approach of using a standard filename follows `/robots.txt` and
`/sitemap.xml` at the site root. And just as `index.html` gives any path
a conventional location for its human-readable entry point, `llms.txt`
gives any path a conventional location for its LLM-readable overview.
robots.txt and `llms.txt` have different purposes. robots.txt lets
automated tools know what access to a site is considered acceptable,
such as for search indexing bots. llms.txt information is instead used
on demand, when an agent needs information about a topic while assisting
a user. Our expectation was that llms.txt would mainly be useful for
*inference* rather than *training*, and that is how it has been used,
though training runs could take advantage of the information too.

An alternative would be the Well-Known URIs standard (RFC 8615), which
reserves the `/.well-known/` prefix for metadata files like this one.
But well-known URIs exist only at the origin root, and many authors
control only a path on a shared host: a GitHub Pages project site, for
example, can publish files in its own directory but can never add one to
the host’s `/.well-known/`. Like `index.html`, an `llms.txt` describes
the path where it sits, something a single root location cannot express.
And anyone who can publish content at a path can provide one.

sitemap.xml is a list of all the indexable human-readable information
available on a site. This isn’t a substitute for `llms.txt` since it:

- Often won’t have the LLM-readable versions of pages listed
- Doesn’t include URLs to external sites, even though they might be
  helpful to understand the information
- Will generally cover documents that in aggregate will be too large to
  fit in an LLM context window, and will include a lot of information
  that isn’t necessary to understand the site.

## Example

Here’s an example of `llms.txt`, in this case a cut down version of the
file used for the FastHTML project (see also the [full
version](https://www.fastht.ml/docs/llms.txt)):

``` markdown
# FastHTML

> FastHTML is a python library which brings together Starlette, Uvicorn, HTMX, and fastcore's `FT` "FastTags" into a library for creating server-rendered hypermedia applications.

Important notes:

- Although parts of its API are inspired by FastAPI, it is *not* compatible with FastAPI syntax and is not targeted at creating API services
- FastHTML is compatible with JS-native web components and any vanilla JS library, but not with React, Vue, or Svelte.

## Docs

- [FastHTML quick start](https://fastht.ml/docs/tutorials/quickstart_for_web_devs.html.md): A brief overview of many FastHTML features
- [HTMX reference](https://github.com/bigskysoftware/htmx/blob/master/www/content/reference.md): Brief description of all HTMX attributes, CSS classes, headers, events, extensions, js lib methods, and config options

## Examples

- [Todo list application](https://github.com/AnswerDotAI/fasthtml/blob/main/examples/adv_app.py): Detailed walk-thru of a complete CRUD app in FastHTML showing idiomatic use of FastHTML and HTMX patterns.

## Optional

- [Starlette full documentation](https://gist.githubusercontent.com/jph00/809e4a4808d4510be0e3dc9565e9cbd3/raw/9b717589ca44cedc8aaf00b2b8cacef922964c0f/starlette-sml.md): A subset of the Starlette documentation useful for FastHTML development. 
```

To create effective `llms.txt` files, consider these guidelines:

- Use concise, clear language.
- When linking to resources, include brief, informative descriptions.
- Avoid ambiguous terms or unexplained jargon.
- Test your file by asking an agent questions about your content, giving
  it only your llms.txt as a starting point.

## Directories

Here are a few directories that list the `llms.txt` files available on
the web:

- [llmstxt.site](https://llmstxt.site/)
- [directory.llmstxt.cloud](https://directory.llmstxt.cloud/)
- [llmstxthub.com](https://llmstxthub.com/)

## Integrations

Many documentation platforms and CMSs can generate an llms.txt file
automatically:

- [Mintlify](https://www.mintlify.com/docs/ai/llmstxt) - Docs platform
  that generates llms.txt and markdown page versions for every site it
  hosts
- [GitBook](https://www.gitbook.com/blog/what-is-llms-txt) - Serves an
  llms.txt file for published docs sites
- [Yoast SEO](https://yoast.com/features/llms-txt/) - WordPress plugin
  that generates and maintains an llms.txt file
- [AIOSEO](https://aioseo.com/features/llms-txt/) - WordPress plugin
  with an llms.txt generator
- [Wix](https://support.wix.com/en/article/understanding-your-sites-llmstxt-file) -
  Generates an llms.txt file for every Wix site

And various libraries and plugins are available to integrate the
llms.txt specification into your workflow:

- [JavaScript Implementation](./llmstxt-js.html) - Sample JavaScript
  implementation
- [`vitepress-plugin-llms`](https://github.com/okineadev/vitepress-plugin-llms) -
  VitePress plugin that automatically generates LLM-friendly
  documentation for the website following the llms.txt specification
- [`docusaurus-plugin-llms`](https://github.com/rachfop/docusaurus-plugin-llms) -
  Docusaurus plugin for generating LLM-friendly documentation following
  the llmtxt.org standard
- [Drupal LLM Support](https://www.drupal.org/project/llm_support) - A
  Drupal Recipe providing full support for the llms.txt proposal on any
  Drupal 10.3+ site
- [`llms-txt-php`](https://github.com/raphaelstolt/llms-txt-php) - A
  library for writing and reading llms.txt Markdown files
- [`VS Code PagePilot Extension`](https://dmux.github.io/pagepilot) -
  PagePilot is a VS Code Chat participant that automatically loads
  external context (documentation, APIs, README files) to provide
  enhanced responses.
- [`server-llm-txt`](https://github.com/mcp-get/community-servers/tree/main/src/server-llm-txt) -
  MCP server that lets agents fetch and search llms.txt files

## Next steps

The `llms.txt` specification is open for community input. A [GitHub
repository](https://github.com/AnswerDotAI/llms-txt) hosts [this
informal
overview](https://github.com/AnswerDotAI/llms-txt/blob/main/nbs/index.qmd),
allowing for version control and public discussion. A [community discord
channel](https://discord.gg/aJPygMvPEN) is available for sharing
implementation experiences and discussing best practices.
