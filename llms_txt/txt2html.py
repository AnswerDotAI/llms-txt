import mistletoe
from pathlib import Path
from fastcore.script import call_parse

@call_parse
def main(
    file_path='llms.txt'  # path to llms.txt file
):
    text = Path(file_path).read_text(encoding="utf-8")
    fragment = mistletoe.markdown(text)
    processed = fragment.replace('.html.md">', '.html">')
    full = f"""<!DOCTYPE html>
    <html>
    <head>
    <title>llms.html</title>
    </head>
    <body>
    {processed}
    </body>
    </html>"""
    Path("llms.html").write_text(full)

