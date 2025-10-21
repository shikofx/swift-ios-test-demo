---
layout: default
title: Project Quality Dashboard
---

### Code Analysis Reports

* 🔎 **Lint:** [View Report](./swiftlint-report.html)

  * **Files:** {{ site.data.swiftlint_summary.total_files }}
  * **Warnings:** {{ site.data.swiftlint_summary.total_warnings }}
  * **Errors:** {{ site.data.swiftlint_summary.total_errors }}

* 🪄 **Format:** [View Report](./swiftformat-report.html)

### Test Reports

* 📈 **Code Coverage:** [View Report](./coverage-report/index.html)
* 📊 **Allure:** [View Report](./allure-report/index.html)

#### Run History

<iframe src="./allure-report/index.html" width="100%" height="800" style="border:1px solid #ddd; border-radius: 5px; margin-top: 15px;">
  Your browser does not support iframes.
</iframe>
