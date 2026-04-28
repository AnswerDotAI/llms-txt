# How to help LLMs understand your nbdev project
Radek Osmulski
2024-01-20

## Overview

This tutorial demonstrates how to add `llms.txt` to your nbdev project,
creating a clear interface between your code and LLMs. You’ll learn to
generate `llms-ctx.txt` and `llms-ctx-full.txt` files and integrate them
with your documentation.

While this guide focuses on `nbdev`, the underlying principles and tools
are framework-agnostic and can help make any codebase more accessible to
LLMs.

Let’s explore how to implement this.

## The key ingredient: llms.txt

The foundation of LLM-friendly documentation is the `llms.txt` file. At
its core, it is just a Markdown file with information about your library
found at a specific URL (root of your site followed by `/llms.txt`).

However, it needs to follow a certain structure as outlined in the
[llms.txt](https://llmstxt.org/#format) format.

Do not be intimidated by the specification, though. In reality, it
offers a lot of flexibility and by conforming to it you’ll gain access
to several very helpful tools that we will look at in a second.

First, let’s start working on our `llms.txt` file. If you would like to,
you can open your favorite editor and start working on an `llms.txt` for
your library as we go along.

Here is how the `llms.txt` file could begin:

``` markdown
# FastHTML

> FastHTML is a python library which...

When writing FastHTML apps remember to:

- Thing to remember
```

The required elements are:

- the H1 header (FastHTML)
- a blockquote with a short summary of the project (FastHTML is a python
  library which…)

And they can optionally be followed by zero or more paragraphs and
lists. Usually, this is the place where you would add a short
description of your library.

The description can be as simple as this (this is an excerpt from the
[llms.txt](https://fastcore.fast.ai/llms.txt) for
[fastcore](https://fastcore.fast.ai/)):

    Here are some tips on using fastcore:

    - **Liberal imports**: Utilize `from fastcore.module import *` freely. The library is designed for safe wildcard imports.
    - **Enhanced list operations**: Substitute `list` with `L`. This provides advanced indexing, method chaining, and additional functionality while maintaining list-like behavior.
    - **Extend existing classes**: Apply the `@patch` decorator to add methods to classes, including built-ins, without subclassing. This enables more flexible code organization.

Below are a few ideas on how to make writing the description feel even
more seamless:

- Consider the content you already have that can be used as a starting
  point (e.g. your project’s README, blog posts and articles, social
  media discussions, etc.)
- Think of how you would describe your library to a new team member —
  this often yields the right balance of precision and comprehension.
- Use an LLM to help you synthetize content from multiple sources into
  cohesive prose (though you might need to do some post-processing to
  combat the LLM’s tendency to be verbose).

### Adding resource sections

After the optional description, you can include zero or more sections
starting with an H2 heading and containing links to supplementary
resources.

Markdown files are strongly recommended here as they offer a good
balance of structure and readability. You could attempt linking to other
formats, but your results may vary. For instance, HTML tends to be
verbose, and formats like CSV rarely contain information that lends
itself well to documenting functionality.

Here’s an example of what this section might look like:

``` markdown
## Docs

- [Surreal](https://host/README.md): Tiny jQuery alternative with Locality of Behavior
- [FastHTML quick start](https://host/quickstart.html.md): An overview of FastHTML features

## Examples

- [Todo app](https://host/adv_app.py)
```

### The Optional section

If you’d like to, you can include a section with `Optional` as the
heading. This section has a special meaning and provides a mechanism for
managing context size. Resources listed in this section appear only in
`llms-ctx-full.txt`, while being omitted from `llms-ctx.txt`. This
allows the user (be that a human or an agent) to choose the right amount
of context based on their use case and the capabilities of the LLM they
plan to use.

- `llms.txt`: just the initial section with an optional description and
  optional resource sections with unexpanded links
- `llms-ctx.txt`: as above but with links expanded apart from the
  ‘Optional’ section
- `llms-ctx-full.txt`: all sections with expanded links

Here is a small example of the `Optional` section:

``` markdown
## Optional

- [Starlette docs](https://host/starlette-sml.md): A subset of the Starlette docs
```

Your `llms.txt` file is now complete! Time to give yourself a pat on the
back for a job well done and let’s move on to the next, automated step.

## Generating context files

The [llms-txt](https://llmstxt.org/intro.html) library automates the
process of generating context files from your `llms.txt`. It can be used
either through its CLI interface or as a Python module.

Using the CLI:

``` bash
llms_txt2ctx llms.txt --save_nbdev_fname llms-ctx.txt
```

Or via Python:

``` python
from llms_txt import *
samp = Path('llms-sample.txt').read_text()
parsed = parse_llms_file(samp)
```

Both approaches read your `llms.txt` file and retrieve the linked
content. This is the process that takes your `llms.txt` and turns it
into `llms-ctx.txt` and `llms-ctx-full.txt`.

But there is another very exciting library —
[pysymbol-llm](https://github.com/AnswerDotAI/pysymbol-llm) — that will
allow us to add even more useful information in an automated way.

## Enhancing context with API reference

While LLMs generally understand high-level concepts, they often struggle
with implementation details, especially when their training data is
outdated. Providing a comprehensive list of your library’s symbols -
functions, classes, and their documentation - helps bridge this gap.

This is where the
[pysymbol-llm](https://github.com/AnswerDotAI/pysymbol-llm) library
enters the picture. It generates a complete API reference in Markdown,
extracting existing docstrings along the way.

This is a short excerpt from the
[apilist.txt](https://fastcore.fast.ai/apilist.txt) for `fastcore`:

``` markdown
# fastcore Module Documentation

## fastcore.ansi

> Filters for processing ANSI colors.

- `def strip_ansi(source)`
    Remove ANSI escape codes from text.

- `def ansi2html(text)`
    Convert ANSI colors to HTML colors.

- `def ansi2latex(text)`
    Convert ANSI colors to LaTeX colors.
```

The tool works great even with larger libraries. For instance,
generating the API reference for numpy requires just one command:

``` bash
pysym2md numpy
```

To implement this in your project, generate an `apilist.txt`, serve it
alongside your documentation, and reference it from your `llms.txt`
file.

## Configuration

The final step is to configure your nbdev project to generate and serve
these context files. This requires three changes:

1.  Add your `llms.txt` file to the `nbs` directory of your project.

2.  Add the required dependencies to `settings.ini`:

<!-- -->

    dev_requirements = pysymbol_llm llms-txt

3.  Configure Quarto’s build process in `nbs/_quarto.yml`:

<!-- -->

    project:
      type: website
      pre-render:
        - pysym2md --output_file apilist.txt nbdev
      post-render:
        - llms_txt2ctx llms.txt --optional true --save_nbdev_fname llms-ctx-full.txt
        - llms_txt2ctx llms.txt --save_nbdev_fname llms-ctx.txt
      resources:
        - "*.txt"

Remember to manually add a link to the generated `apilist.txt` in your
`llms.txt` file. Once you commit these changes and rebuild your docs,
your library will be ready for deeper, more accurate conversations with
LLMs!

## Learning from examples

It is often useful to study how others went about implementing the thing
we are working on. The [fastcore](https://fastcore.fast.ai/llms.txt) and
[FastHTML](https://fastht.ml/docs/) projects offer a good reference, and
you can find additional examples in the
[llmstxt.site](https://llmstxt.site/) and
[llmstxt.cloud](https://directory.llmstxt.cloud/) directories.

To see all the necessary changes in one place, here’s a [complete
example](https://github.com/AnswerDotAI/nbdev/pull/1485/files) of adding
`llms.txt` to an existing nbdev project.

Providing the right context opens up new possibilities for AI-assisted
development and exploring topics you might want to learn more about. We
hope this guide helps you and the users of your library take advantage
of these exciting new tools.
