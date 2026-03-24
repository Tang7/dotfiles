---
paths:
  - "src/api/**"
  - "src/services/**"
---

# API Conventions (scoped to src/api/ and src/services/)

All API endpoints must:
1. Return standard response shape: `{ data, error, meta }`
2. Include rate-limiting middleware
3. Log the request (method, path, duration)
4. Validate input at the boundary — never trust raw request body
