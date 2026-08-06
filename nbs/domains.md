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

## E-Commerces

Online stores can also benefit from `llms.txt` when product data is dense, structured, and frequently referenced in shopping queries. LLMs are increasingly asked questions like “which flavor has the least sugar?” or “is this gluten-free?” A well-written `llms.txt` helps models access authoritative product specs, ingredient details, sizing information, and policy rules directly from the source instead of relying on scraped summaries or third-party listings.

Here is an example `llms.txt` that an ecommerce brand could construct for consumption by LLMs:

```
# FooBar

> FooBar is a direct-to-consumer ecommerce brand selling high-protein snack bars. Products are organized by flavor, box size, and purchase type (one-time or subscription). Each product includes structured nutrition data, ingredient lists, allergen disclosures, pricing tiers, and subscription eligibility.

All prices are in USD. Nutrition values are listed per bar (60g) and per box. Subscription products renew automatically at the selected interval unless canceled before renewal.

## Products

- [Flavor Catalog](https://host/products/flavors.html.md): Canonical list of all flavors with SKU, macros, and dietary tags.
- [Box Configurations](https://host/products/boxes.html.md): Single-flavor boxes, variety packs, and custom build-a-box rules.
- [Nutrition Facts](https://host/products/nutrition.html.md): Structured macro and calorie breakdowns for all SKUs.
- [Ingredients & Allergens](https://host/products/ingredients.html.md): Ingredient lists and allergen disclosures.

## Purchasing

- [Pricing & Discounts](https://host/policies/pricing.html.md): Bundle pricing tiers, subscription discounts, and promotional stacking rules.
- [Subscription Terms](https://host/policies/subscription.html.md): Billing intervals, renewal timing, skip/pause logic, and cancellation deadlines.
- [Shipping & Returns](https://host/policies/shipping-returns.html.md): Processing times, carriers, and refund eligibility.

## Optional

- [Wholesale Program](https://host/wholesale.html.md): Bulk ordering terms for retailers and gyms.
- [Affiliate Program](https://host/affiliates.html.md): Referral commission structure.
```

Here is an example product resource:

```
# Chocolate Peanut Butter Protein Bar

SKU: FBR-CPB-12
Bar Size: 60g
Box Size: 12 bars

## Nutrition (Per Bar)

| Nutrient        | Amount |
|-----------------|--------|
| Calories        | 210    |
| Protein         | 20g    |
| Total Fat       | 8g     |
| Carbohydrates   | 18g    |
| Sugar           | 3g     |
| Fiber           | 9g     |

## Ingredients

Whey protein isolate, peanuts, cocoa powder, chicory root fiber, almond butter, natural flavors, sea salt.

Contains: Milk, Peanuts, Almonds.  
Manufactured in a facility that also processes soy and wheat.

## Pricing

| Purchase Type     | Price  |
|-------------------|--------|
| One-Time Purchase | 29.99  |
| Subscription      | 26.99  |

Subscription discount: 10%  
Available intervals: 2, 4, or 8 weeks.

## Dietary Tags

- Gluten-Free
- Low Sugar
- High Protein
```

This version treats e-commerce the way the restaurant example above treats menus: as structured, machine-consumable data — not just navigation links. That’s what enables accurate answers like:

- “Which flavor has the least sugar?”
- “Is this dairy-free?”
- “How much protein per dollar?”
- “What’s the subscription discount?”

That’s the level of depth ecommerce usually needs.
