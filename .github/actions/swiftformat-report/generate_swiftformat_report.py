import json
import os
import argparse
import re
from html import escape

def camel_to_title(name):
    """Converts a camelCase string to a Title Case string."""
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1 \2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1 \2', s1).title()

def generate_swiftformat_html_report(json_path, output_path, github_workspace):
    """
    Generates a Markdown report from a SwiftFormat JSON output.
    The report includes a summary and a detailed list of violations,
    formatted for Jekyll with Front Matter.
    """
    if not os.path.exists(json_path):
        print(f"::warning::SwiftFormat report not found at {json_path}. Skipping page generation.")
        return

    with open(json_path, 'r', encoding='utf-8') as f:
        violations = json.load(f)

    total_violations = len(violations)

    # Build table rows from violations
    table_rows_html = []
    for i, violation in enumerate(violations):
        relative_file_path = os.path.relpath(violation['file'], start=github_workspace)
        path_text = f"{escape(relative_file_path)}:{violation['line']}"
        rule_id = violation['rule_id']
        rule_display = camel_to_title(rule_id)
        reason = escape(violation['reason'])

        row = f"""
        <tr>
          <td>{i + 1}</td>
          <td class="copyable" onclick="copyToClipboard(this)">{path_text}</td>
          <td>
            <div class="lint-rule">
              <a href="https://github.com/nicklockwood/SwiftFormat/blob/master/Rules.md#{rule_id.lower()}" target="_blank">{rule_display}</a>
            </div>
            <div class="lint-reason">{reason}</div>
          </td>
        </tr>
        """
        table_rows_html.append(row)

    # Construct the final HTML content
    if not violations:
        body_content = "<h3>SwiftFormat Style Violations</h3>\n<p>No SwiftFormat violations found. Your code is perfectly formatted! ✨</p>"
    else:
        body_content = f"""
        <h3>SwiftFormat Style Violations ({total_violations})</h3>
        <table class="lint-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Path (click to copy)</th>
                    <th>Reason</th>
                </tr>
            </thead>
            <tbody>
                {''.join(table_rows_html)}
            </tbody>
        </table>
        """

    html_content = f"""
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SwiftFormat Style Report</title>
<style>
    body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji"; margin: 20px; }}
    .lint-table {{ width: 100%; border-collapse: collapse; font-size: 12px; }}
    .lint-table th, .lint-table td {{ border: 1px solid #ddd; padding: 8px; text-align: left; vertical-align: top; }}
    .lint-table th:nth-child(1), .lint-table td:nth-child(1) {{ width: 5%; }}
    .lint-table th:nth-child(2), .lint-table td:nth-child(2) {{ width: 40%; }}
    .lint-table th:nth-child(3), .lint-table td:nth-child(3) {{ width: 55%; }}
    .lint-rule {{ font-weight: bold; }}
    .lint-reason {{ font-style: italic; }}
    .lint-table th {{ background-color: #f2f2f2; }}
    .copyable {{ cursor: pointer; }}
    .copyable:hover {{ background-color: #f0f0f0; }}
</style>
<script>
    function copyToClipboard(element) {{
        const originalText = element.innerText;
        navigator.clipboard.writeText(originalText).then(function() {{
            console.log('Copied to clipboard: ' + originalText);
            element.innerText = 'Copied';
            setTimeout(function() {{ element.innerText = originalText; }}, 500);
        }}, function(err) {{
            console.error('Could not copy text: ', err);
            element.innerText = 'Copy Failed!';
            setTimeout(function() {{ element.innerText = originalText; }}, 500);
        }});
    }}
</script>
</head>
<body>
    {body_content}
</body>
</html>
"""

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html_content)

    print(f"SwiftFormat HTML report generated at {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate SwiftFormat Markdown report.")
    parser.add_argument("--json-path", required=True, help="Path to the SwiftFormat JSON report.")
    parser.add_argument("--output-path", required=True, help="Path to the output Markdown file.")
    parser.add_argument("--github-workspace", required=True, help="GitHub workspace path to strip from file paths.")
    args = parser.parse_args()
    generate_swiftformat_html_report(args.json_path, args.output_path, args.github_workspace)