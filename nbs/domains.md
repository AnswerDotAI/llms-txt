# llms.txt Guidelines

This page has some guidelines and suggestions for how different domains could utilize `llms.txt` to allow LLMs to better interface with their site if they so choose.

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

- [Dessert Mneu](https://host/dessert.md): A subset of the Starlette docs
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