"""Bundle this prototype as a self-contained conversation preview fragment."""

import argparse
import base64
import mimetypes
from pathlib import Path
import re


def build(destination):
    source = Path(__file__).resolve().parent
    html = (source / "index.html").read_text()
    fragment = html.split("<body>", 1)[1].split("</body>", 1)[0].strip()
    css = (source / "company.css").read_text().replace("body{margin:0}", "")
    css = css.replace("min-height:100vh", "min-height:0")
    javascript = (source / "company.js").read_text()

    def data_url(relative_path):
        path = source / relative_path
        mime = mimetypes.guess_type(path)[0] or "application/octet-stream"
        encoded = base64.b64encode(path.read_bytes()).decode("ascii")
        return f"data:{mime};base64,{encoded}"

    fragment = re.sub(
        r'src="(assets/[^\"]+)"',
        lambda match: f'src="{data_url(match[1])}"',
        fragment,
    )
    css = re.sub(
        r"url\((assets/[^)]+)\)",
        lambda match: f"url({data_url(match[1])})",
        css,
    )
    output = f"<style>\n{css}\n</style>\n{fragment}\n<script>\n{javascript}\n</script>\n"
    if len(output.encode()) >= 1_000_000:
        raise ValueError("Conversation preview must remain below 1 MB")
    destination.write_text(output)
    print(f"Built {destination} ({len(output.encode()):,} bytes)")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("destination", type=Path)
    build(parser.parse_args().destination)
