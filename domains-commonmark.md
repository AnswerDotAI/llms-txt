

# llms.txt in Different Domains

This page has some guidelines and suggestions for how different domains
could utilize `llms.txt` to allow LLMs to better interface with their
site if they so choose.

Remember, when constructing your `llms.txt` you should “use concise,
clear language. When linking to resources, include brief, informative
descriptions. Avoid ambiguous terms or unexplained jargon.”
Additionally, the best way to determine if your `llms.txt` works well
with LLMs is to test it with them! Here is a minimal way to test
Anthropic’s Claude against your `llms.txt`:

``` python
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

The above script utilizes the relatively new
[`uv`](https://docs.astral.sh/uv/) syntax for python scripts. If you
install `uv`, you can simply run the above script with
`uv run test_llms_txt.py` and it will handle installing the necessary
library dependencies in an isolated python environment. Else you can
install the requirements manually and run it like any ordinary python
script with `python test_llms_txt.py`.

## Restaurants

Here is an example `llms.txt` that a restaurant could construct for
consumption by LLMs:

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

    - [Dessert Mneu](https://host/dessert.md): A subset of the Starlette docs

And here is an example lunch menu taken from [Franklin’s
BBQ](https://franklinbbq.com/menu):

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
