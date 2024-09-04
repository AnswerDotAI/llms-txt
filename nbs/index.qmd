---
title: "The /llms.txt file"
date: 2024-09-03
author: "Jeremy Howard"
description: "A proposal to standardise on using an `/llms.txt` file to provide information to help LLMs use a website at inference time."
image: "/sample.png"
---

## Background

Today websites are not just used to provide information to people, but they are also used to provide information to large language models. For instance, language models are often used to enhance development environments used by coders, with many systems including an option to ingest information about programming libraries and APIs from website documentation.

Providing information for language models is a little different to providing information for humans, although there is plenty of overlap. Language models generally like to have information in a more concise form. This can be more similar to what a human expert would want to read. Language models can ingest a lot of information quickly, so it can be helpful to have a single place where all of the key information can be collated---not for training (since training generally involved scraping all pages in all readable formats), but for helping users accessing the site via AI helpers.

Context windows are too small to handle most websites in their entirety, and converting HTML pages with complex navigation, ads, Javascript, etc into LLM-friendly plain text documents is difficult and imprecise. Therefore it would be helpful if there was a way to identify the most important information to provide to AI helpers, in the most appropriate form.

## Proposal

![llms.txt logo](logo.png){.lightbox width=150px .floatr}

We propose that those interested in providing LLM-friendly content add a `/llms.txt` file to their site. This is a markdown file that provides brief background information and guidance, along with links to markdown files (which can also link to external sites) providing more detailed information. This can be used, for instance, in order to provide information necessary for coders to use a library, or as part of research to learn about a person or organization and so forth. You are free to use the `llms.txt` logo on your site to indicate your support if you wish.

llms.txt markdown is human and LLM readable, but is also in a precise format allowing fixed processing methods (i.e. classical programming techniques such as parsers and regex). For instance, there is an [llms-txt](/intro.html) project providing a CLI and Python module for parsing `llms.txt` files and generating LLM context from them. There is also a [sample JavaScript](/llmstxt-js.html) implementation.

We furthermore propose that pages on websites that have information that might be useful for LLMs to read provide a clean markdown version of those pages at the same URL as the original page, but with `.md` appended. (URLs without file names should append `index.html.md` instead.)

The [FastHTML project](https://fastht.ml) follows these two proposals for its documentation. For instance, here is the [FastHTML docs llms.txt](https://docs.fastht.ml/llms.txt). And here is an example of a [regular HTML docs page](https://docs.fastht.ml/tutorials/by_example.html), along with exact same URL but with [a .md extension](https://docs.fastht.ml/tutorials/by_example.html.md). Note that all [nbdev](https://nbdev.fast.ai/) projects now create .md versions of all pages by default, and all Answer.AI and fast.ai software projects using nbdev have had their docs regenerated with this feature---for instance, see the [markdown version](https://fastcore.fast.ai/docments.html.md) of [fastcore's docments module](https://fastcore.fast.ai/docments.html).

This proposal does not include any particular recommendation for how to process the file, since it will depend on the application. For example, FastHTML automatically builds a new version of two markdown files including the contents of the linked URLs, using an XML-based structure suitable for use in LLMs such as Claude. The two files are: [llms-ctx.txt](https://docs.fastht.ml/llms-ctx.txt), which does not include the optional URLs, and [llms-ctx-full.txt](https://docs.fastht.ml/llms-ctx-full.txt), which does include them. They are created using the [`llms_txt2ctx`](https://llmstxt.org/intro.html#cli) command line application, and the FastHTML documentation includes information for users about how to use them.

llms.txt files can be used in various scenarios. For software libraries, they can provide a structured overview of documentation, making it easier for LLMs to locate specific features or usage examples. In corporate websites, they can outline organizational structure and key information sources. Information about new legislation and necessary background and context could be curated in an `llms.txt` file to help stakeholders understand it.

llms.txt files can be adapted for various domains. Personal portfolio or CV websites could use them to help answer questions about an individual. In e-commerce, they could outline product categories and policies. Educational institutions might use them to summarize course offerings and resources.

## Format

At the moment the most widely and easily understood format for language models is Markdown. Simply showing where key Markdown files can be found is a great first step. Providing some basic structure helps a language model to find where the information it needs can come from.

The `llms.txt` file is unusual in that it uses Markdown to structure the information rather than a classic structured format such as XML. The reason for this is that we expect many of these files to be read by language models and agents. Having said that, the information in `llms.txt` follows a specific format and can be read using standard programmatic-based tools.

The `llms.txt` file spec is for files located in the root path `/llms.txt` of a website (or, optionally, in a subpath). A file following the spec contains the following sections as markdown, in the specific order:

- An H1 with the name of the project or site. This is the only required section
- A blockquote with a short summary of the project, containing key information necessary for understanding the rest of the file
- Zero or more markdown sections (e.g. paragraphs, lists, etc) of any type except headings, containing more detailed information about the project and how to interpret the provided files
- Zero or more markdown sections delimited by H2 headers, containing "file lists" of URLs where further detail is available
  - Each "file list" is a markdown list, containing a required markdown hyperlink `[name](url)`, then optionally a `:` and notes about the file.

Here is a mock example:

```markdown
# Title

> Optional description goes here

Optional details go here

## Section name

- [Link title](https://link_url): Optional link details

## Optional

- [Link title](https://link_url)
```

Note that the "Optional" section has a special meaning---if it's included, the URLs provided there can be skipped if a shorter context is needed. Use it for secondary information which can often be skipped.

## Existing standards

llms.txt is designed to coexist with current web standards. While sitemaps list all pages for search engines, `llms.txt` offers a curated overview for LLMs. It can complement robots.txt by providing context for allowed content. The file can also reference structured data markup used on the site, helping LLMs understand how to interpret this information in context.

The approach of standardising on a path for the file follows the approach of `/robots.txt` and `/sitemap.xml`. robots.txt and `llms.txt` have different purposes---robots.txt is generally used to let automated tools what access to a site is considered acceptable, such as for search indexing bots. On the other hand, `llms.txt` information will often be used on demand when a user explicitly requesting information about a topic, such as when including a coding library's documentation in a project, or when asking a chat bot with search functiontionality for information. Our expectation is that `llms.txt` will mainly be useful for *inference*, i.e. at the time a user is seeking assistance, as opposed to for *training*. However, perhaps if `llms.txt` usage becomes widespread, future training runs could take advantage of the information in `llms.txt` files too.

sitemap.xml is a list of all the indexable human-readable information available on a site. This isn’t a substitute for `llms.txt` since it:

- Often won’t have the LLM-readable versions of pages listed
- Doesn’t include URLs to external sites, even although they might be helpful to understand the information
- Will generally cover documents that in aggregate will be too large to fit in an LLM context window, and will include a lot of information that isn’t necessary to understand the site.

## Example

Here’s an example of `llms.txt`, in this case a cut down version of the file used for the FastHTML project (see also the [full version](https://docs.fastht.ml/llms.txt):

```markdown
# FastHTML

> FastHTML is a python library which brings together Starlette, Uvicorn, HTMX, and fastcore's `FT` "FastTags" into a library for creating server-rendered hypermedia applications.

Important notes:

- Although parts of its API are inspired by FastAPI, it is *not* compatible with FastAPI syntax and is not targeted at creating API services
- FastHTML is compatible with JS-native web components and any vanilla JS library, but not with React, Vue, or Svelte.

## Docs

- [FastHTML quick start](https://docs.fastht.ml/path/quickstart.html.md): A brief overview of many FastHTML features
- [HTMX reference](https://raw.githubusercontent.com/path/reference.md): Brief description of all HTMX attributes, CSS classes, headers, events, extensions, js lib methods, and config options

## Examples

- [Todo list application](https://raw.githubusercontent.com/path/adv_app.py): Detailed walk-thru of a complete CRUD app in FastHTML showing idiomatic use of FastHTML and HTMX patterns.

## Optional

- [Starlette full documentation](https://gist.githubusercontent.com/path/starlette-sml.md): A subset of the Starlette documentation useful for FastHTML development.
```

To create effective `llms.txt` files, consider these guidelines: Use concise, clear language. When linking to resources, include brief, informative descriptions. Avoid ambiguous terms or unexplained jargon. Run a tool that expands your `llms.txt` file into an LLM context file and test a number of language models to see if they can answer questions about your content.

## Next steps

The `llms.txt` specification is open for community input. A [GitHub repository](https://github.com/AnswerDotAI/llms-txt) hosts [this informal overview](https://github.com/AnswerDotAI/llms-txt/blob/main/nbs/index.md), allowing for version control and public discussion. A community discord channel is available for sharing implementation experiences and discussing best practices.

