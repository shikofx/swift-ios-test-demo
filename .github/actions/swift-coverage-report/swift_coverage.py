import json
import os
import argparse
import html
import sys

JS_SCRIPT = """
<script defer>
    function sortFiles(sortBy) {
        const container = document.getElementById('files-container');
        const files = Array.from(container.getElementsByTagName('details'));

        let sortedFiles;
        switch (sortBy) {
            case 'name_asc':
                sortedFiles = files.sort((a, b) => a.dataset.name.localeCompare(b.dataset.name));
                break;
            case 'name_desc':
                sortedFiles = files.sort((a, b) => b.dataset.name.localeCompare(a.dataset.name));
                break;
            case 'coverage_asc':
                sortedFiles = files.sort((a, b) => parseFloat(a.dataset.coverage) - parseFloat(b.dataset.coverage));
                break;
            case 'coverage_desc':
                sortedFiles = files.sort((a, b) => parseFloat(b.dataset.coverage) - parseFloat(a.dataset.coverage));
                break;
            default:
                sortedFiles = files;
        }

        // Re-append sorted elements
        sortedFiles.forEach(file => container.appendChild(file));
    }
</script>
"""

def get_line_coverage_map(file_info, source_code_lines):
    line_map = {}
    for func in file_info.get('functions', []):
        start_line = func['lineNumber']
        execution_count, name = func['executionCount'], func['name']

        brace_count = 0
        in_function = False
        for i in range(start_line - 1, len(source_code_lines)):
            line = source_code_lines[i]
            if i == start_line - 1:
                in_function = True
            
            if in_function:
                brace_count += line.count('{')
                brace_count -= line.count('}')
                line_map[i + 1] = ("covered" if execution_count > 0 else "not-covered", name)
                if brace_count == 0 and line.strip().endswith('}'):
                    break
    return line_map

def generate_code_view_html(file_info, source_dir, repo_url, branch):
    try:
        relative_path = os.path.relpath(file_info['path'], start=source_dir)
        if ".." in relative_path:
            return None

        with open(file_info['path'], 'r', encoding='utf-8') as f:
            source_code_lines = f.readlines()
    except FileNotFoundError:
        return None

    line_coverage_map = get_line_coverage_map(file_info, source_code_lines)
    code_html = '<div class="code-container"><pre style="font-size: 12px;">'

    for i, line in enumerate(source_code_lines):
        line_num = i + 1
        coverage_info = line_coverage_map.get(line_num)
        line_class = coverage_info[0] if coverage_info else ""
        title_text = f"Function: {coverage_info[1]}" if coverage_info else ""
        title_attr = f'title="{html.escape(title_text)}"' if title_text else ""

        code_html += f'<div class="line {line_class}" {title_attr}>'
        code_html += f'<span class="line-number">{line_num}</span>'
        code_html += f'<span class="line-content">{html.escape(line.rstrip())}</span>'
        code_html += '</div>'

    return code_html + "</pre></div>"

def main(json_path, source_dir, output_path):
    with open(json_path, 'r') as f:
        coverage_data = json.load(f)

    repo_url = f"https://github.com/{os.getenv('GITHUB_REPOSITORY', '')}"
    branch = os.getenv('GITHUB_REF_NAME', 'main')

    app_target = next((t for t in coverage_data['targets'] if t['name'].endswith('.app')), None)
    if not app_target:
        print("Warning: Could not find main application target in coverage data.")
        return

    total_app_covered_lines = 0
    total_app_executable_lines = 0
    files_html_blocks = []

    for file_info in sorted(app_target['files'], key=lambda x: x['path']):
        relative_path = os.path.relpath(file_info['path'], start=source_dir)

        if ".." in relative_path or "Pods/" in file_info['path']:
            continue

        total_app_covered_lines += file_info['coveredLines']
        total_app_executable_lines += file_info['executableLines']

        coverage = file_info['lineCoverage'] * 100
        color = '#4CAF50' if coverage > 70 else ('#FFC107' if coverage > 40 else '#F44336')
        
        code_view_html = generate_code_view_html(file_info, source_dir, repo_url, branch)

        file_html = f"""
        <details data-name="{html.escape(relative_path)}" data-coverage="{coverage}">
            <summary>
                <div class="summary-left">
                    <a href="{repo_url}/blob/{branch}/{relative_path}" target="_blank" class="file-name-link">{html.escape(relative_path)}</a>
                </div>
                <div class="summary-right">
                    <span class="coverage-percent">{coverage:.2f}%</span>
                    <span class="coverage-bar">
                        <span class="coverage-fill" style="width: {coverage}%; background-color: {color};"></span>
                    </span>
                </div>
            </summary>
            {code_view_html}
        </details>
        """
        files_html_blocks.append(file_html)

    real_coverage = (total_app_covered_lines / total_app_executable_lines * 100) if total_app_executable_lines > 0 else 0
    real_coverage_color = '#4CAF50' if real_coverage > 70 else ('#FFC107' if real_coverage > 40 else '#F44336')

    # Jekyll Front Matter
    md_content = f"""---
layout: page
title: Code Coverage Report
---

{{% comment %}}
This file is autogenerated. Do not edit it manually.
{{% endcomment %}}

<link rel="stylesheet" href="{{ '/assets/css/swift-coverage-report.css' | relative_url }}">
{JS_SCRIPT}

<div class="coverage-report-container">
    <div class="report-summary">
            <div class="summary-item">
                <h3>Real App Coverage</h3>
                <p style="color: {real_coverage_color};">{real_coverage:.2f}%</p>
            </div>
            <div class="summary-item">
                <h3>Covered Lines</h3>
                <p>{total_app_covered_lines}</p>
            </div>
            <div class="summary-item">
                <h3>Executable Lines</h3>
                <p>{total_app_executable_lines}</p>
            </div>
        </div>

    <div class="sort-container">
        <select onchange="sortFiles(this.value)">
            <option value="name_asc">Sort by Name (A-Z)</option>
            <option value="name_desc">Sort by Name (Z-A)</option>
            <option value="coverage_asc">Sort by Coverage (Low to High)</option>
            <option value="coverage_desc">Sort by Coverage (High to Low)</option>
        </select>
    </div>
    <div id="files-container">
        {''.join(files_html_blocks)}
    </div>
</div>
    """
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"Markdown report generated at {output_path}")

if __name__ == "__main__":
    sys.stdout.reconfigure(encoding='utf-8')
    parser = argparse.ArgumentParser(description="Generate HTML coverage report from xccov JSON.")
    parser.add_argument("--json-path", required=True, help="Path to the input coverage.json file.")
    parser.add_argument("--source-dir", required=True, help="Path to the source code directory.")
    parser.add_argument("--output-path", required=True, help="Path where the output Markdown report file will be created.")
    args = parser.parse_args()
    main(args.json_path, args.source_dir, args.output_path)