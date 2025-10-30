---
layout: default
title: SwiftLint Style Report
total_files: 1
total_warnings: 2
total_errors: 0
violations:

- {"character":34,"file":"/Users/runner/work/swift-ios-test-demo/swift-ios-test-demo/SDET Demo App/Constants/Methods.swift","line":20,"reason":"Colons should be next to the identifier when specifying a type and next to the key in dictionary literals","rule_id":"colon","severity":"Warning","type":"Colon Spacing"}
- {"character":43,"file":"/Users/runner/work/swift-ios-test-demo/swift-ios-test-demo/SDET Demo App/Constants/Methods.swift","line":23,"reason":"Colons should be next to the identifier when specifying a type and next to the key in dictionary literals","rule_id":"colon","severity":"Warning","type":"Colon Spacing"}
---
## Summary
| Metric | Value |
|---|---|
| Total files with violations | {{ page.total_files }} |
| Total warnings | {{ page.total_warnings }} |
| Total errors | {{ page.total_errors }} |

## SwiftLint Style Report

{% if page.violations.size > 0 %}
| # | File | Location | Severity | Reason |
|---|------|----------|----------|--------|
{% for item_str in page.violations -%}
{%- assign item = item_str | from_json -%}
| {{ forloop.index }} | {{ item.file }} | {{ item.line }}:{{ item.character | default: "N/A" }} | {{ item.severity }} | {{ item.type }}: {{ item.reason | escape }} |
{%- endfor %}
{% else %}
No SwiftLint violations found. Your code is clean! ✨
{% endif %}
