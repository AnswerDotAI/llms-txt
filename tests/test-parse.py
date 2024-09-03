import unittest
from llms_txt.miniparse import parse_llms_txt

class TestParseLlmsFileShort(unittest.TestCase):
    def test_basic_parsing(self):
        txt = """# Title

> Optional description goes here

Optional details go here

## Section name

- [Link title](https://link_url): Optional link details

## Optional

- [Link title](https://link_url)
"""
        result = parse_llms_txt(txt)
        self.assertEqual(result['title'], 'Title')
        self.assertEqual(result['summary'], 'Optional description goes here')
        self.assertEqual(result['info'], 'Optional details go here')
        self.assertIn('Section name', result['sections'])
        self.assertIn('Optional', result['sections'])
        self.assertEqual(len(result['sections']['Section name']), 1)
        self.assertEqual(len(result['sections']['Optional']), 1)

    def test_multiple_links(self):
        txt = """# Another Title

> Another description

More details

## Links

- [Google](https://google.com): Search engine
- [OpenAI](https://openai.com)

## More Info

- [Python](https://python.org): Programming language
"""
        result = parse_llms_txt(txt)
        self.assertEqual(result['title'], 'Another Title')
        self.assertEqual(result['summary'], 'Another description')
        self.assertEqual(result['info'], 'More details')
        self.assertEqual(len(result['sections']['Links']), 2)
        self.assertEqual(len(result['sections']['More Info']), 1)

    def test_missing_optional_fields(self):
        txt = """# Only Title

Only details here

## Section

- [Item](https://example.com)
"""
        result = parse_llms_txt(txt)
        self.assertEqual(result['title'], 'Only Title')
        self.assertIsNone(result.get('summary'))
        self.assertEqual(result['info'], 'Only details here')
        self.assertIn('Section', result['sections'])
        self.assertEqual(len(result['sections']['Section']), 1)

    def test_no_links(self):
        txt = """# No Links Title

> No description

Some details without links
"""
        result = parse_llms_txt(txt)
        self.assertEqual(result['title'], 'No Links Title')
        self.assertEqual(result['summary'], 'No description')
        self.assertEqual(result['info'], 'Some details without links')
        self.assertEqual(result['sections'], {})

unittest.main()
