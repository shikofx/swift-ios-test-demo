import json
import os
import argparse
from html import escape

def snake_to_title(name):
    """Converts a snake_case string to a Title Case string."""
    return name.replace('_', ' ').title()

def generate_swiftlint_html_report(json_path, output_path, github_workspace):
    """
    Generates a standalone HTML report from a SwiftLint JSON output.
    The report includes a summary and a detailed list of violations,
    with filtering and copy-to-clipboard functionality.
    """
    if not os.path.exists(json_path):
        print(f"::warning::SwiftLint report not found at {json_path}. Skipping page generation.")
        return

    with open(json_path, 'r', encoding='utf-8') as f:
        violations = json.load(f)

    # Calculate summary statistics
    unique_files = set()
    total_warnings = 0
    total_errors = 0

    for v in violations:
        unique_files.add(v['file'])
        if v['severity'] == 'Warning':
            total_warnings += 1
        elif v['severity'] == 'Error':
            total_errors += 1

    total_files = len(unique_files)

    # Collect unique rules for the filter dropdown
    unique_rules = sorted(list(set(v['rule_id'] for v in violations)))

    # Build table rows from violations
    table_rows_html = []
    for i, violation in enumerate(violations):
        relative_file_path = os.path.relpath(violation['file'], start=github_workspace)
        relative_file_path = relative_file_path.replace("SDET Demo App/", "", 1)

        severity_class = f"severity-{violation['severity'].lower()}"
        path_text = f"{escape(relative_file_path)}:{violation['line']}"
        rule_id = violation['rule_id']
        rule_display = snake_to_title(rule_id)
        reason = escape(violation['reason'])

        row = f"""
        <tr data-severity="{violation['severity'].lower()}" data-rule="{escape(rule_id)}">
          <td class="{severity_class}">{i + 1}</td>
          <td class="copyable" onclick="copyToClipboard(this)">{path_text}</td>
          <td>
            <div class="lint-type">
              <a href="https://realm.github.io/SwiftLint/{rule_id}.html" target="_blank">{rule_display}</a>
            </div>
            <div class="lint-reason">{reason}</div>
          </td>
        </tr>
        """
        table_rows_html.append(row)

    # Construct the final HTML content
    if not violations:
        body_content = "<h3>SwiftLint Style Violations</h3>\n<p>No SwiftLint violations found. Your code is clean! ✨</p>"
    else:
        # Create dropdown options for rules
        rule_options = '<option value="all">All Rules</option>'
        for rule in unique_rules:
            rule_options += f'<option value="{escape(rule)}">{snake_to_title(rule)}</option>'

        body_content = f"""
        <div class="header-controls">
            <h3>SwiftLint Style Violations</h3>
            <div class="filters-container">
                <div class="filter-buttons">
                    <button id="filter-severity-all" class="active" onclick="applyFilters('all', null)">All ({total_warnings + total_errors})</button>
                    <button id="filter-severity-warning" onclick="applyFilters('warning', null)">Warnings ({total_warnings})</button>
                    <button id="filter-severity-error" onclick="applyFilters('error', null)">Errors ({total_errors})</button>
                </div>
                <select id="rule-filter" onchange="applyFilters(null, this.value)">
                    {rule_options}
                </select>
            </div>
        </div>
        <iframe id="report-iframe" srcdoc="{escape(f'''
            <!DOCTYPE html>
            <html>
            <head>
            <style>
              body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji"; margin: 0; }}
                .lint-table {{ width: 100%; border-collapse: collapse; font-size: 12px; }}
                .lint-table th, .lint-table td {{ border: 1px solid #ddd; padding: 8px; text-align: left; vertical-align: top; }}
                .lint-table th:nth-child(1), .lint-table td:nth-child(1) {{ width: 5%; }}
                .lint-table th:nth-child(2), .lint-table td:nth-child(2) {{ width: 40%; }}
                .lint-table th:nth-child(3), .lint-table td:nth-child(3) {{ width: 55%; }}
                .lint-type, .lint-rule {{ font-weight: bold; }}
                .lint-reason {{ font-style: italic; }}
                .lint-table th {{ background-color: #f2f2f2; }}
                .severity-warning {{ background-color: #FFD700; }}
                .severity-error {{ background-color: #FF4136; color: white; }}
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
            </body>
            </html>
        ''')}" style="width: 100%; height: 100vh; border: 1px solid #ddd; border-radius: 5px;"></iframe>
        """

    html_content = f"""
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SwiftLint Style Report</title>
<style>
    body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji"; margin: 20px; }}
    .header-controls {{ display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }}
    .filters-container {{ display: flex; align-items: center; gap: 20px; }}
    .filter-buttons button {{ margin-left: 5px; padding: 5px 10px; cursor: pointer; border: 1px solid #ccc; background-color: #f0f0f0; border-radius: 4px; }}
    .filter-buttons button.active {{ background-color: #007bff; color: white; border-color: #007bff; }}
    #rule-filter {{ padding: 5px; border-radius: 4px; border: 1px solid #ccc; }}
</style>
<script>
    document.addEventListener('DOMContentLoaded', () => {{
        let currentSeverityFilter = 'all';
        let currentRuleFilter = 'all';

        window.applyFilters = function(severityFilter, ruleFilter) {{
            if (severityFilter !== null) {{
                currentSeverityFilter = severityFilter;
                document.querySelectorAll('.filter-buttons button').forEach(btn => btn.classList.remove('active'));
                document.getElementById('filter-severity-' + severityFilter).classList.add('active');
            }}
            if (ruleFilter !== null) {{
                currentRuleFilter = ruleFilter;
            }}

            const iframe = document.getElementById('report-iframe');
            if (!iframe) return;
            const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
            const rows = iframeDoc.querySelectorAll('tbody tr');

            rows.forEach(row => {{
                const severityMatch = currentSeverityFilter === 'all' || row.dataset.severity === currentSeverityFilter;
                const ruleMatch = currentRuleFilter === 'all' || row.dataset.rule === currentRuleFilter;
                row.style.display = (severityMatch && ruleMatch) ? '' : 'none';
            }});
        }}

        applyFilters(null, null);
    }});
</script>
</head>
<body>
    {body_content}
</body>
</html>
"""

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html_content)

    print(f"SwiftLint HTML report generated at {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate SwiftLint Markdown report.")
    parser.add_argument("--json-path", required=True, help="Path to the SwiftLint JSON report.")
    parser.add_argument("--output-path", required=True, help="Path to the output Markdown file.")
    parser.add_argument("--github-workspace", required=True, help="GitHub workspace path to strip from file paths.")
    args = parser.parse_args()
    generate_swiftlint_html_report(args.json_path, args.output_path, args.github_workspace)
