import json
import os
import argparse
import html

def generate_swiftlint_report(json_path, output_path, github_workspace):
    """
    Generates a Markdown report from a SwiftLint JSON output.
    The report includes a summary and a detailed list of violations,
    formatted for Jekyll with Front Matter.
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

    # Start building the Markdown content with Jekyll Front Matter
    md_content = f"""---
layout: default
title: SwiftLint Style Report
total_files: {total_files}
total_warnings: {total_warnings}
total_errors: {total_errors}
violations:
"""

    # Process each violation and append to the Front Matter as a YAML list of JSON strings
    for violation in violations:
        # Strip GITHUB_WORKSPACE prefix
        # Using os.path.relpath for more robust path handling
        relative_file_path = os.path.relpath(violation['file'], start=github_workspace)
        
        # Additionally strip "SDET Demo App/" if present, as per original jq logic
        # This assumes "SDET Demo App" is a fixed part of the path to be removed.
        # Using replace with count=1 to only replace the first occurrence
        relative_file_path = relative_file_path.replace("SDET Demo App/", "", 1)

        processed_violation = {
            "file": relative_file_path,
            "line": violation['line'],
            "character": violation['character'],
            "severity": violation['severity'],
            "type": violation['rule_id'], # Using rule_id as type for consistency
            "reason": violation['reason']
        }
        # Serialize the dictionary to a JSON string and prepend with "- " for YAML list format
        md_content += f"- {json.dumps(processed_violation)}\n"

    # Append the rest of the Jekyll template (HTML table and JavaScript for filtering)
    # This part is directly copied from the original action.yml
    md_content += """
---
### SwiftLint Style Violations

{% if page.violations.size > 0 %}
<div class="filter-buttons">
  <button id="filter-all" onclick="applyFilter('all')">All ({{ page.total_warnings | plus: page.total_errors }})</button>
  <button id="filter-warning" onclick="applyFilter('warning')">Warnings ({{ page.total_warnings }})</button>
  <button id="filter-error" onclick="applyFilter('error')">Errors ({{ page.total_errors }})</button>
</div>
{% capture table_html %}
  <!DOCTYPE html>
  <html>
  <head>
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji"; margin: 0; }
      .lint-table { width: 100%; border-collapse: collapse; font-size: 12px; }
      .lint-table th, .lint-table td { border: 1px solid #ddd; padding: 8px; text-align: left; vertical-align: top; }
      .lint-table th:nth-child(1), .lint-table td:nth-child(1) { width: 5%; }
      .lint-table th:nth-child(2), .lint-table td:nth-child(2) { width: 40%; }
      .lint-table th:nth-child(3), .lint-table td:nth-child(3) { width: 55%; }
      .lint-type { font-weight: bold; }
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
        {%- assign severity_class = "severity-" | append: item.severity | downcase -%}
        <tr>
          <td class="{{ severity_class }}">{{ forloop.index }}</td>
          <td class="copyable" onclick="copyToClipboard(this)">{{ item.file }}:{{ item.line }}</td>
          <td>
            <div class="lint-type">{{ item.type }}</div> 
            <div class="lint-reason">{{ item.reason | escape }}</div>
          </td>
        </tr>
        {%- endfor %}
      </tbody>
    </table>
  </body>
  </html>
{% endcapture %}
<iframe srcdoc="{{ table_html | escape }}" style="width: 100%; height: 600px; border: 1px solid #ddd; border-radius: 5px;"></iframe>

<script>
  function applyFilter(filter) {
    const iframe = document.querySelector('iframe');
    const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
    const rows = iframeDoc.querySelectorAll('.lint-table tbody tr');

    rows.forEach(row => {
      const severityCell = row.querySelector('td:first-child');
      if (filter === 'all') {
        row.style.display = '';
      } else if (severityCell) {
        if (severityCell.classList.contains('severity-' + filter)) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      }
    });

    // Update URL and button styles
    const url = new URL(window.location);
    url.searchParams.set('filter', filter);
    window.history.pushState({}, '', url);
    
    document.querySelectorAll('.filter-buttons button').forEach(btn => btn.classList.remove('active'));
    document.getElementById('filter-' + filter).classList.add('active');
  }

  document.addEventListener("DOMContentLoaded", function() {
    const params = new URLSearchParams(window.location.search);
    const filter = params.get('filter') || 'all';
    applyFilter(filter);
  });
</script>
{% else %}
No SwiftLint violations found. Your code is clean! ✨
{% endif %}
"""

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"SwiftLint Markdown page generated at {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate SwiftLint Markdown report.")
    parser.add_argument("--json-path", required=True, help="Path to the SwiftLint JSON report.")
    parser.add_argument("--output-path", required=True, help="Path to the output Markdown file.")
    parser.add_argument("--github-workspace", required=True, help="GitHub workspace path to strip from file paths.")
    args = parser.parse_args()
    generate_swiftlint_report(args.json_path, args.output_path, args.github_workspace)