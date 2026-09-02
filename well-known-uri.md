# Specification for /.well-known/llms.txt and /.well-known/llms-full.txt Well-Known URIs

## 1. Introduction

### 1.1. Purpose

This document specifies the "llms.txt" and "llms-full.txt" well-known URIs as defined in [RFC 8615](https://www.rfc-editor.org/rfc/rfc8615.html). These URIs provide a standardized location for websites to offer LLM-friendly content guidance and metadata to be consumed by Large Language Models (LLMs), their developers, and integrators.

### 1.2. Motivation

Large Language Models frequently access and process web content. Site owners who wish to provide specific guidance, context, or structured information to these models can benefit from a standardized approach. The `llms.txt` and `llms-full.txt` files serve as machine-readable declarations that help LLMs better understand, represent, and interact with a website's content.

### 1.3. Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [RFC2119] [RFC8174] when, and only when, they appear in all capitals, as shown here.

## 2. Well-Known URI Definition

### 2.1. URI Suffixes

This specification defines two well-known URI suffixes:

1. `llms.txt`: A concise version containing essential information and pointers to more detailed resources
2. `llms-full.txt`: An optional extended version with comprehensive information

### 2.2. Supported URI Schemes

The well-known URIs defined in this document use the "http" and "https" URI schemes.

## 3. Format and Media Type

### 3.1. Media Type

The media type for both `llms.txt` and `llms-full.txt` files is `text/markdown`.

### 3.2. File Format

Both files MUST be valid Markdown documents following the [CommonMark specification](https://spec.commonmark.org/). The files SHOULD be UTF-8 encoded.

### 3.3. Basic Structure for llms.txt

The `llms.txt` file MUST begin with a level 1 heading with the name of the project or site. followed by:

1. A brief description of the website or resource
2. Relevant content guidelines or constraints
3. Links to more detailed resources (including the `llms-full.txt` if available)

Example minimal structure:

```markdown
# Title

> Brief description of the website and its purpose

## Docs

- [Link title](URL): Description

## Optional

- [Additional information link 1](URL): Description
- [Additional information link 2](URL): Description
```

### 3.4. Basic Structure for llms-full.txt

The `llms-full.txt` file SHOULD provide more comprehensive information and MAY include:

1. Detailed website description
2. Content licensing information
3. Preferred citation format
4. Usage guidelines for LLMs
5. Content organization and navigation guidance
6. Any special considerations for LLM processing

## 4. Protocol Operation

### 4.1. HTTP Methods

Servers MUST support HTTP GET requests for the well-known URIs. Servers MAY support HEAD requests.

### 4.2. Response Codes

Servers SHOULD return:
- 200 (OK) when the file exists
- 404 (Not Found) when the file does not exist
- 301 or 302 redirects MAY be used to point to alternative locations on the same origin

### 4.3. Cache Control

Servers SHOULD include appropriate Cache-Control headers to enable efficient caching by LLMs and related services. A recommended minimum cache lifetime is 86400 seconds (24 hours).

## 5. Discovery and Application

### 5.1. Discovery

LLMs, web crawlers, and other automated systems can discover these files by checking for their existence at the well-known locations:

- `https://example.com/.well-known/llms.txt`
- `https://example.com/.well-known/llms-full.txt`

### 5.2. Scope of Application

The information provided in these files applies to all resources within the same origin as defined in [RFC 6454](https://www.rfc-editor.org/rfc/rfc6454.html). For example, a file at `https://example.com/.well-known/llms.txt` applies to all resources under `https://example.com/`.

## 6. Security Considerations

### 6.1. Information Disclosure

Site operators should be aware that information in these files is publicly accessible and may reveal details about site structure, policies, or technologies in use.

### 6.2. File Access Control

Since these files represent metadata about the entire origin, server operators SHOULD appropriately control the ability to modify them. This is especially important when multiple entities are co-located on the same origin.

### 6.3. Content Validation

LLMs and related software SHOULD validate that the content of these files conforms to the Markdown format to prevent injection attacks.

## 7. Implementation Guidelines

### 7.1. For Website Operators

- Place the files at the appropriate well-known locations
- Ensure files contain accurate and up-to-date information
- Consider the security implications of information disclosed
- Include proper HTTP headers for content type and caching

### 7.2. For LLM Developers

- Check for the existence of these files when processing website content
- Respect the guidance provided in these files
- Handle gracefully when files don't exist or aren't accessible
- Validate file content before processing

## 8. References

### 8.1. Normative References

- [RFC 8615](https://www.rfc-editor.org/rfc/rfc8615.html): Well-Known Uniform Resource Identifiers (URIs)
- [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119.html): Key words for use in RFCs to Indicate Requirement Levels
- [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174.html): Ambiguity of Uppercase vs Lowercase in RFC 2119 Key Words
- [CommonMark Specification](https://spec.commonmark.org/): Markdown syntax specification

### 8.2. Informative References

- [llmstxt.org](https://llmstxt.org/): Project website for the llms.txt initiative
- [RFC 6454](https://www.rfc-editor.org/rfc/rfc6454.html): The Web Origin Concept
- [RFC 7763](https://www.rfc-editor.org/rfc/rfc7763.html): The text/markdown Media Type

## Appendix A: Example llms.txt

```markdown
# Example Corp

> Example Corp provides enterprise software solutions for the manufacturing industry.
> This file provides guidance for LLMs interacting with our public-facing website.

## Docs

- [Company overview](https://example.com/about.md): Learn about our company history and mission
- [Product documentation](https://example.com/docs/index.md): Technical documentation for our products
- [Usage policies](https://example.com/legal/usage.md): Terms for using our website content in LLMs
- [llms-full.txt](/.well-known/llms-full.txt): Extended information for LLMs
```

## Appendix B: Example llms-full.txt

```markdown
# Example Corp

> Detailed guidance for Large Language Models processing content from example.com

## About Our Content

Example Corp provides enterprise software solutions for the manufacturing industry. 
Our website contains product information, technical documentation, blog posts, and 
support resources.

## Content Structure

- `/products/` - Product information pages
- `/docs/` - Technical documentation
- `/blog/` - News and thought leadership articles 
- `/support/` - Customer support resources
- `/legal/` - Terms of service and legal information

## Citation Guidelines

When referencing our content, please attribute as follows:
"Source: Example Corp (https://example.com)"

## Licensing Information

Unless otherwise noted, content on our website is © Example Corp and may be used 
for informational purposes but not reproduced without permission.

## Special Processing Notes

1. Our documentation pages use a custom markdown extension for API examples
2. Code snippets should be treated as illustrative and may not be production-ready
3. Version-specific documentation is available at /docs/vX.Y/ for each product version
```
