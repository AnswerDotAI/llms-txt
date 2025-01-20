

# `ed`, the standard text editor

In order to understand how llms.txt can be used with editors and IDEs,
let’s look at how `ed`, the [standard text
editor](https://www.gnu.org/fun/jokes/ed-msg.html), could work (assuming
it’s updated to use this proposal). In our example we will look at how
the user might then tell `ed` to retrieve the LLM docs from
[docs.fastht.ml](https://docs.fastht.ml), and then use the results to
write a simple [FastHTML](https://fastht.ml) web app.

Even if you use a non-standard editor or IDE such as vscode, Cursor,
vim, or Emacs, your software’s interaction with `/llms.txt` would look
similar to this general approach.

``` sh
$ ed
* H
```

Our user starts `ed` and enables helpful error messages (just for the
purpose of this walkthru - obviously a real `ed` user doesn’t need
“helpful error messages”).

``` sh
* L docs.fastht.ml
Checking for /llms.txt at docs.fastht.ml...
Found /llms.txt. Parsing...
Fetching URLs from "Docs" section...  Fetching URLs from "Examples" section...
Skipping "Optional" section for brevity.
Creating XML-based context for Claude...  Context created and loaded.
```

The user invokes the hypothetical `L` (load) command, which in this
LLM-enhanced version of `ed` retrieves and processes the `llms.txt`
file. `ed` checks for the file (if it didn’t exist, it would fall back
to scraping the HTML of the website the old-fashioned way), parses it,
fetches the relevant URLs, and creates an XML-based context suitable for
Claude (perhaps an `ed` config file could be used to choose what LLM to
use, and would determine how the context is formatted). All of this
happens with the characteristic silence of `ed`, broken only by these
reassuring progress messages.

``` sh
* x Create a simple FastHTML app which outputs 'Hello, World!', in a <div>.
Analyzing context and prompt...
Generating FastHTML app...
App written to buffer.
```

Next, our user invokes the hypothetical `x` (eXecute AI) command,
providing instructions for the LLM to create a simple FastHTML app. In
the world of LLM-enhanced `ed`, this is understood as a request to
generate code based on the given prompt and the previously loaded
context.

``` sh
* n
5
* p
from fasthtml.common import *
app,rt = fast_app()
@rt
def index(): return div("Hello, World!")
serve()
```

The editor analyzes the loaded context along with the provided prompt,
generates the FastHTML app, and writes it to the buffer. The user then
views the generated app line count (`n`) and contents (`p`), marveling
at how much functionality is packed into those 5 lines.

``` sh
*w hello_world.py
5
*q
```

Finally, our user saves the app to a file and quits `ed`, presumably to
run their new FastHTML app and reflect on the unexpected productivity
boost provided by their trusty line editor.
