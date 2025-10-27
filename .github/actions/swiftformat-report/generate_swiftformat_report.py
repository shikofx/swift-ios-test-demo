import json
import os
import argparse
import html
import re

def camel_to_title(name):
    """Converts a camelCase string to a Title Case string."""
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1 \2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1 \2', s1).title()

def generate_swiftformat_report(json_path, output_path, github_workspace):
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

    # Calculate summary statistics
    unique_files = set()
    total_violations = len(violations)

    for v in violations:
        unique_files.add(v['file'])

    total_files = len(unique_files)

    # Start building the Markdown content with Jekyll Front Matter
    md_content = f"""---
layout: default
title: SwiftFormat Style Report
total_files: {total_files}
total_violations: {total_violations}
violations:
"""

    # Process each violation and append to the Front Matter as a YAML list of JSON strings
    for violation in violations:
        # Strip GITHUB_WORKSPACE prefix
        relative_file_path = os.path.relpath(violation['file'], start=github_workspace)
        
        processed_violation = {
            "file": relative_file_path,
            "line": violation['line'],
            "rule": violation['rule_id'],
            "rule_display": camel_to_title(violation['rule_id']),
            "reason": violation['reason']
        }
        # Serialize the dictionary to a JSON string and prepend with "- " for YAML list format
        md_content += f"- {json.dumps(processed_violation)}\n"

    # Append the rest of the Jekyll template (HTML table)
    md_content += """
---
### SwiftFormat Style Violations

{% if page.violations.size > 0 %}
{% capture table_html %}
  <!DOCTYPE html>
  <html>
  <head>
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji"; margin: 0; }
      .lint-table { width: 100%; border-collapse: collapse; font-size: 12px; }
      .lint-table th, .lint-table td { border: 1px solid #ddd; padding: 8px; text-align: left; vertical-align: top; }
      /* SwiftFormat specific column widths */
      .lint-table th:nth-child(1), .lint-table td:nth-child(1) { width: 5%; }
      .lint-table th:nth-child(2), .lint-table td:nth-child(2) { width: 40%; }
      .lint-table th:nth-child(3), .lint-table td:nth-child(3) { width: 55%; }

      .lint-type, .lint-rule { font-weight: bold; }
      .lint-reason { font-style: italic; }
      .lint-table th { background-color: #f2f2f2; }
      .severity-warning { background-color: #FFD700; } /* Gold */
      .severity-error { background-color: #FF4136; color: white; } /* Red */
      .copyable { cursor: pointer; }
      .copyable:hover { background-color: #f0f0f0; }
    </style>
    <script>
      function copyToClipboard(element) {
        const originalText = element.innerText;
        navigator.clipboard.writeText(originalText).then(function() {
          console.log('Copied to clipboard: ' + originalText);
          element.innerText = 'Copied';
          setTimeout(function() {
            element.innerText = originalText;
          }, 500);
        }, function(err) {
          console.error('Could not copy text: ', err);
          element.innerText = 'Copy Failed!';
          setTimeout(function() {
            element.innerText = originalText;
          }, 500);
        });
      }
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
        {% for item_str in page.violations -%}
        {%- assign item = item_str | from_json -%}
        <tr>
          <td>{{ forloop.index }}</td>
          <td class="copyable" onclick="copyToClipboard(this)">{{ item.file }}:{{ item.line }}</td>
          <td>
            <div class="lint-rule">
              <a href="https://github.com/nicklockwood/SwiftFormat/blob/master/Rules.md#{{ item.rule }}" target="_blank">{{ item.rule_display }}</a>
            </div>
            <div class="lint-reason">{{ item.reason | escape }}</div>
          </td>
        </tr>
        {%- endfor %}
      </tbody>
    </table>
  </body>
  </html>
{% endcapture %}
<iframe id="report-iframe" srcdoc="{{ table_html | escape }}" style="width: 100%; border: 1px solid #ddd; border-radius: 5px;"></iframe>

<script>
  function resizeIframe() {
    const iframe = document.getElementById('report-iframe');
    const headerHeight = document.querySelector('header').offsetHeight;
    const h3Height = document.querySelector('h3').offsetHeight;
    const availableHeight = window.innerHeight - headerHeight - h3Height - 150; // 150px for paddings/margins
    iframe.style.height = Math.max(availableHeight, 400) + 'px'; // Minimum height of 400px
  }
  document.addEventListener('DOMContentLoaded', resizeIframe);
  window.addEventListener('resize', resizeIframe);
</script>
{% else %}
No SwiftFormat violations found. Your code is perfectly formatted! ✨
{% endif %}
"""

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"SwiftFormat Markdown page generated at {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate SwiftFormat Markdown report.")
    parser.add_argument("--json-path", required=True, help="Path to the SwiftFormat JSON report.")
    parser.add_argument("--output-path", required=True, help="Path to the output Markdown file.")
    parser.add_argument("--github-workspace", required=True, help="GitHub workspace path to strip from file paths.")
    args = parser.parse_args()
    generate_swiftformat_report(args.json_path, args.output_path, args.github_workspace)