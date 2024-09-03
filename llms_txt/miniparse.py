from pathlib import Path
import re,itertools

def chunked(it, chunk_sz):
    it = iter(it)
    return iter(lambda: list(itertools.islice(it, chunk_sz)), [])

def parse_llms_txt(txt):
    "Parse llms.txt file contents in `txt` to a `dict`"
    def _p(links):
        link_pat = '-\s*\[(?P<title>[^\]]+)\]\((?P<url>[^\)]+)\)(?::\s*(?P<desc>.*))?'
        return [re.search(link_pat, l).groupdict()
                for l in re.split(r'\n+', links.strip()) if l.strip()]

    start,*rest = re.split(fr'^##\s*(.*?$)', txt, flags=re.MULTILINE)
    sects = {k: _p(v) for k,v in dict(chunked(rest, 2)).items()}
    pat = '^#\s*(?P<title>.+?$)\n+(?:^>\s*(?P<summary>.+?$)$)?\n+(?P<info>.*)'
    d = re.search(pat, start.strip(), (re.MULTILINE|re.DOTALL)).groupdict()
    d['sections'] = sects
    return d

