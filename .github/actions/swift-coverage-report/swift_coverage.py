import json
import os
import argparse
import html
import sys

CSS_STYLES = """
<style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji";}
    .coverage-report-container { max-width: 1200px; margin: 5px auto; }
    .report-summary { display: flex; justify-content: space-around; margin-bottom: 20px; background-color: #f9f9f9; padding: 10px; border-radius: 5px; border: 1px solid #ddd; }
    .summary-item { text-align: center; }
    .summary-item h3 { margin: 0 0 5px 0; font-size: 14px; color: #555; }
    .summary-item p { margin: 0; font-size: 20px; font-weight: bold; }
    details { border: 1px solid #ddd; border-radius: 5px; margin-bottom: 5px; overflow: hidden; }
    summary { display: flex; justify-content: space-between; align-items: center; padding: 10px; font-weight: bold; cursor: pointer; background-color: #f9f9f9; }
    summary:hover { background-color: #f1f1f1; }
    .summary-left { display: flex; align-items: center; }
    .file-name-link { font-weight: normal; font-size: 14px; text-decoration: none; color: #267CB9; }
    .file-name-link:hover { text-decoration: underline; }
    .summary-right { display: flex; align-items: center; }
    .coverage-bar { display: inline-block; height: 12px; background-color: #ccc; border-radius: 3px; overflow: hidden; width: 100px; vertical-align: middle; margin-left: 10px; }
    .coverage-fill { height: 100%; display: block; }
    .coverage-percent { min-width: 60px; text-align: right; font-family: monospace; }
    .code-container { border-top: 1px solid #ddd; padding: 10px; background-color: #f9f9f9; overflow-x: auto; }
    .code-container pre { margin: 0; }
    .line { display: flex; line-height: 1.2; }
    .line-number { min-width: 40px; color: #999; text-align: right; padding-right: 10px; user-select: none; }
    .line-content { white-space: pre; }
    .covered { background-color: #e6ffed; }
    .not-covered { background-color: #ffebe9; }
    .sort-container { margin-bottom: 10px; text-align: right; }
    .sort-container select { padding: 4px; font-size: 12px; border-radius: 4px; }
</style>
"""
JS_SCRIPT = """
<script>
document.addEventListener('DOMContentLoaded', () => {
    window.sortFiles = function(sortBy) {
        const container = document.getElementById('files-container');
        if (!container) return;
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
        }
        sortedFiles.forEach(file => container.appendChild(file));
    }
});
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

def main(json_path, source_dir, output_path, repo_root):
    print("--- Starting Coverage Report Generation ---")
    print(f"JSON Path: {json_path}")
    print(f"Source Directory: {source_dir}")
    print(f"Output Path: {output_path}")
    print(f"Repo Root (raw): {repo_root}")

    with open(json_path, 'r') as f:
        coverage_data = json.load(f)

    repo_url = f"https://github.com/{os.getenv('GITHUB_REPOSITORY', '')}"
    branch = os.getenv('GITHUB_REF_NAME', 'main')

    app_target = next((t for t in coverage_data.get('targets', []) if t['name'].endswith('.app')), None)
    if not app_target:
        print("Warning: Could not find main application target in coverage data.")
        return

    total_app_covered_lines = 0
    total_app_executable_lines = 0
    files_html_blocks = []

    # Convert repo_root to an absolute path for reliable comparison
    absolute_repo_root = os.path.abspath(repo_root) if repo_root else None
    print(f"Repo Root (absolute): {absolute_repo_root}")

    # Get the repository name (e.g., 'swift-ios-test-demo') to help find the project root in paths
    repo_name = os.getenv('GITHUB_REPOSITORY', '').split('/')[-1]
    print(f"Repository Name: {repo_name}")

    print(f"\nFound app target: '{app_target['name']}' with {len(app_target['files'])} files.")

    for file_info in sorted(app_target['files'], key=lambda x: x['path']):
        original_path = file_info['path']
        print(f"\nProcessing file: {original_path}")

        if "Pods/" in original_path:
            print(" -> Skipping: File is in 'Pods/' directory.")
            continue

        # --- RESTRUCTURED LOGIC TO FIX PATHS ---
        # Try to find the repo name in the original path to determine the project-relative path
        path_parts = original_path.split(os.sep)
        try:
            # Find the index of the directory that is the repo name
            repo_name_index = path_parts.index(repo_name)
            # The relative path starts from the directory *after* the repo name
            project_relative_path = os.path.join(*path_parts[repo_name_index+1:])
            # Construct the absolute path on the runner
            path_on_runner = os.path.join(absolute_repo_root, project_relative_path)
            
            print(f" -> Found repo '{repo_name}' in path. Relative path: {project_relative_path}")
            print(f" -> Constructed runner path: {path_on_runner}")
            # IMPORTANT: Update the path in file_info to the correct runner path
            file_info['path'] = path_on_runner
            relative_path = project_relative_path # Use this for display
        except ValueError:
            print(f" -> Skipping: Could not find repo name '{repo_name}' in path '{original_path}'.")
            continue
        # --- END OF RESTRUCTURED LOGIC ---
        
        total_app_covered_lines += file_info['coveredLines']
        total_app_executable_lines += file_info['executableLines']

        coverage = file_info['lineCoverage'] * 100
        color = '#4CAF50' if coverage > 70 else ('#FFC107' if coverage > 40 else '#F44336')
        
        code_view_html = generate_code_view_html(file_info, source_dir, repo_url, branch)
        if code_view_html is None:
            print(f" -> Skipping: Could not generate code view (file not found at '{file_info['path']}'?).")
            continue

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

    # This check is important. If no files were processed, we should know.
    if not files_html_blocks:
        print("\n--- WARNING ---")
        print("No source files were processed. The generated report will be empty.")
        print("This is likely due to a path mismatch between the coverage.json file and the repository structure on the runner.")

    real_coverage = (total_app_covered_lines / total_app_executable_lines * 100) if total_app_executable_lines > 0 else 0
    real_coverage_color = '#4CAF50' if real_coverage > 70 else ('#FFC107' if real_coverage > 40 else '#F44336')

    print("\n--- Report Summary ---")
    print(f"Total App Covered Lines: {total_app_covered_lines}")
    print(f"Total App Executable Lines: {total_app_executable_lines}")
    print(f"Final Calculated Coverage: {real_coverage:.2f}%")

    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Code Coverage Report</title>
    {CSS_STYLES}
    {JS_SCRIPT}
</head>
<body>
    <div class="coverage-report-container">
        <h4>Code Coverage Report</h4>
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
</body>
</html>
    """
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"\nHTML report generated at {output_path}")

if __name__ == "__main__":
    sys.stdout.reconfigure(encoding='utf-8')
    parser = argparse.ArgumentParser(description="Generate a standalone HTML coverage report from xccov JSON.")
    parser.add_argument("--json-path", required=True, help="Path to the input coverage.json file.")
    parser.add_argument("--source-dir", required=True, help="Path to the source code directory.")
    parser.add_argument("--output-path", required=True, help="Path where the output HTML report file will be created.")
    parser.add_argument("--repo-root", required=False, help="The root of the repository, for making paths relative in CI.")
    args = parser.parse_args()
    main(args.json_path, args.source_dir, args.output_path, args.repo_root)