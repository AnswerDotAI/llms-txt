# llms.txt in Different Domains

This page has some guidelines and suggestions for how different domains could utilize `llms.txt` to allow LLMs to better interface with their site if they so choose.

Remember, when constructing your `llms.txt` you should "use concise, clear language. When linking to resources, include brief, informative descriptions. Avoid ambiguous terms or unexplained jargon." Additionally, the best way to determine if your `llms.txt` works well with LLMs is to test it with them! Here is a minimal way to test Anthropic's Claude against your `llms.txt`:

```python
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "claudette",
#     "llms-txt",
#     "requests",
# ]
# ///
from claudette import *
from llms_txt import create_ctx

import requests

model = models[1] # Sonnet 3.5
chat = Chat(model, sp="""You are a helpful and concise assistant.""")

url = 'your_url/llms.txt'
text = requests.get(url).text
llm_ctx = create_ctx(text)
chat(llm_ctx + '\n\nThe above is necessary context for the conversation.')

while True:
    msg = input('Your question about the site: ')
    res = chat(msg)
    print('From Claude:', contents(res))
```

The above script utilizes the relatively new [`uv`](https://docs.astral.sh/uv/) syntax for python scripts. If you install `uv`, you can simply run the above script with `uv run test_llms_txt.py` and it will handle installing the necessary library dependencies in an isolated python environment. Else you can install the requirements manually and run it like any ordinary python script with `python test_llms_txt.py`.

## Restaurants

Here is an example `llms.txt` that a restaurant could construct for consumption by LLMs:

```
# Nate the Great's Grill

> Nate the Great's Grill is a popular destination off of Sesame Street that has been serving the community for over 20 years. We offer the best BBQ for a great price.

Here are our weekly hours:

- Monday - Friday: 9am - 9pm
- Saturday: 11am - 9pm
- Sunday: Closed

## Menus

- [Lunch Menu](https://host/lunch.html.md): Our lunch menu served from 11am to 4pm every day.
- [Dinner Menu](https://host/dinner.html.md): Our dinner menu served from 4pm to 9pm every day.

## Optional

- [Dessert Menu](https://host/dessert.md): A subset of the Starlette docs
```

And here is an example lunch menu taken from [Franklin's BBQ](https://franklinbbq.com/menu):

```
## By The Pound

| Item              | Price         |
| --------------    | -----------   |
| Brisket           | 34            |
| Pork Spare Ribs   | 30            |
| Pulled Pork       | 28            |

## Drinks

| Item              | Price         |
| --------------    | -----------   |
| Iced Tea          | 3             |
| Mexican Coke      | 3             |

## Sides

| Item              | Price         |
| --------------    | -----------   |
| Potato Salad      | 4             |
| Slaw              | 4             |
```

## SaaS Products

SaaS products are one of the most natural fits for `llms.txt` since developers and end users are already asking LLMs questions about APIs, configuration, and integrations. A well-structured `llms.txt` lets those LLMs answer with your actual docs instead of outdated guesses from training data.

When writing an `llms.txt` for a SaaS product, it helps to lead with what the product *does* rather than what it *is* - "cloud-based project management platform" is less useful to an LLM than explaining the core workflow or paradigm the product follows. It's also worth separating conceptual docs from API references in your H2 sections, since an LLM working with a developer needs endpoint details while an LLM helping an end user needs workflow explanations. Changelogs, migration guides, and advanced configuration are good candidates for `## Optional`, since an LLM helping someone get started doesn't need a v2-to-v3 migration guide in context.

Here is an example `llms.txt` that a SaaS product could use:

```
# Beacon Analytics

> Beacon Analytics is a privacy-first web analytics platform that tracks visitor behavior without cookies or personal data collection. It provides real-time dashboards, event funnels, and retention analysis through a single embedded script tag or server-side API.

All timestamps in the API are UTC. Dashboard data refreshes every 60 seconds. Historical data is retained for 24 months on all plans.

## Docs

- [Getting Started](https://host/docs/quickstart.html.md): Install the tracking script and verify your first pageview in under five minutes.
- [Events and Funnels](https://host/docs/events.html.md): Define custom events, build multi-step funnels, and set conversion goals.
- [Dashboard Guide](https://host/docs/dashboard.html.md): Navigate the real-time dashboard, apply filters, create saved views, and schedule email reports.
- [Team Management](https://host/docs/teams.html.md): Invite team members, assign roles, and configure per-project access controls.

## API Reference

- [Authentication](https://host/api/auth.html.md): Generate API keys, rotate secrets, and authenticate requests using Bearer tokens.
- [Events API](https://host/api/events.html.md): Send events server-side, batch event payloads, and query event history with filters.
- [Export API](https://host/api/export.html.md): Export raw event data as CSV or JSON for a given date range and optional event type filter.

## Integrations

- [WordPress Plugin](https://host/docs/integrations/wordpress.html.md): Install and configure the official WordPress plugin for automatic pageview and form tracking.
- [Segment Source](https://host/docs/integrations/segment.html.md): Forward Segment events to Beacon using the cloud-mode source connector.
- [Webhooks](https://host/docs/integrations/webhooks.html.md): Configure real-time webhook notifications for threshold alerts and goal completions.

## Optional

- [Changelog](https://host/docs/changelog.html.md): Release notes, breaking changes, and deprecation notices by version.
- [Migrating from Google Analytics](https://host/docs/migration-ga.html.md): Map GA concepts to Beacon equivalents, import historical data, and replicate saved reports.
- [On-Premise Deployment](https://host/docs/self-hosted.html.md): Run Beacon on your own infrastructure using Docker Compose or Kubernetes Helm charts.
```

Note that the blockquote explains what Beacon does *and* clarifies a key design decision (no cookies, no personal data) that an LLM would need for accurate answers about privacy and compliance. The free-form section includes operational details (UTC timestamps, refresh intervals, retention policy) that apply globally but would clutter individual doc pages. The H2 sections are organized by audience - `Docs` for end users, `API Reference` for developers integrating programmatically, and `Integrations` for connecting Beacon to other tools.

And here is what a linked page like the Events API reference might look like as a markdown resource:

```
## Send Event

POST /api/v1/events

| Parameter     | Type       | Required | Description                                        |
| ------------- | ---------- | -------- | -------------------------------------------------- |
| name          | string     | yes      | Event name, e.g. "button_click" or "signup"        |
| url           | string     | no       | Page URL where the event occurred                  |
| referrer      | string     | no       | Referring URL                                       |
| metadata      | object     | no       | Arbitrary key-value pairs (max 10 keys, 256 chars) |
| timestamp     | ISO 8601   | no       | Defaults to server receipt time if omitted          |

Returns `201 Created` with an `event_id` on success or a `422` with validation errors.

## Batch Events

POST /api/v1/events/batch

Accepts an array of up to 100 event objects in a single request. Each event follows the same schema as Send Event above. Returns `201` with an array of `event_id` values in the same order.

## Query Events

GET /api/v1/events

| Parameter     | Type       | Required | Description                                        |
| ------------- | ---------- | -------- | -------------------------------------------------- |
| start_date    | ISO 8601   | yes      | Beginning of the query range (inclusive)            |
| end_date      | ISO 8601   | yes      | End of the query range (exclusive)                  |
| name          | string     | no       | Filter by event name                               |
| limit         | integer    | no       | Max results per page (default 100, max 1000)        |
| cursor        | string     | no       | Pagination cursor from a previous response          |

Returns a paginated list of events matching the filters, sorted by timestamp descending.
```

## Local Government

Government websites serve an enormous range of information (permits, public records, meeting schedules, municipal codes) to an audience that is often unfamiliar with bureaucratic structure. An LLM that can navigate a city's `llms.txt` can help residents find what they need without having to know which department handles what.

For government sites, it helps to explain the organizational structure in the blockquote or details section, since an LLM can only route questions correctly if it understands how the agency is organized. Operational details that people actually call about - office hours, holiday closures, payment methods, processing times - fit well in the free-form section, since those are the high-frequency questions that don't need a linked page to answer. Municipal code, ordinances, and official policies are worth linking as authoritative references even if they're dense, since LLMs can summarize them for residents but only if they can access the actual text. Meeting minutes, historical budgets, and large datasets are good candidates for `## Optional` since they're valuable to specific users (journalists, researchers, engaged residents) but would overwhelm a general-purpose context window.

Here is an example `llms.txt` for a city government site:

```
# City of Maplewood

> The City of Maplewood is a municipality of approximately 45,000 residents in the state of Oregon. The city government provides services including public safety, parks and recreation, utilities, planning and zoning, and public works. City Hall is located at 100 Main Street, Maplewood, OR 97000.

City Hall is open Monday through Friday, 8am to 5pm, and closed on federal holidays. The general information line is (555) 100-2000. Most permits and payments can be submitted online through the resident portal.

The City Council meets on the first and third Tuesday of each month at 7pm in Council Chambers. Agendas are posted 72 hours in advance.

## Resident Services

- [Permits and Licensing](https://host/services/permits.html.md): Apply for building permits, business licenses, and special event permits. Includes fee schedules, required documents, and typical processing times.
- [Utility Billing](https://host/services/utilities.html.md): Water, sewer, and stormwater billing cycles, rate tables, payment options, and instructions for starting or stopping service.
- [Parks and Recreation](https://host/services/parks.html.md): Park locations, shelter reservations, recreation program registration, and community center hours.
- [Public Records Requests](https://host/services/records.html.md): Submit public records requests under Oregon Public Records Law. Includes request form, estimated response times, and fee schedule for copies.

## Departments

- [Planning and Zoning](https://host/departments/planning.html.md): Zoning map, land use applications, code compliance, and information on the Comprehensive Plan update process.
- [Public Works](https://host/departments/public-works.html.md): Street maintenance schedules, snow removal routes, sidewalk repair requests, and capital improvement project status.
- [Police Department](https://host/departments/police.html.md): Non-emergency contact, online report filing, community programs, and sex offender registry lookup.

## Municipal Code

- [Maplewood Municipal Code](https://host/code/municipal-code.html.md): Full text of the city's municipal code, organized by title and chapter.
- [Recent Ordinances](https://host/code/ordinances.html.md): Ordinances adopted in the current calendar year with effective dates and brief summaries.

## Optional

- [Council Meeting Minutes](https://host/council/minutes.html.md): Approved minutes from City Council meetings, organized by date.
- [Annual Budget](https://host/finance/budget.html.md): Current fiscal year adopted budget including departmental allocations, capital projects, and revenue projections.
- [GIS and Map Data](https://host/data/gis.html.md): Downloadable GIS shapefiles and interactive maps for zoning, parcels, floodplains, and infrastructure.
```

Note that the link descriptions here are longer than in the SaaS example. Government terminology is unfamiliar to most residents, so the descriptions provide enough context for an LLM to route a plain-language question like "how do I get a permit for my deck" to the right resource without needing to fetch every linked page. The H2 sections are organized the way a resident thinks - by what they need to do (`Resident Services`), by who handles it (`Departments`), and by legal authority (`Municipal Code`).
