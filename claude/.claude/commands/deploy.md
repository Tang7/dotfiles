# /project:deploy

Prepare a deployment checklist for the current branch.

!git log main...HEAD --oneline
!npm run lint 2>&1 | tail -20

Based on the commits and lint output above:
1. Summarize what will be deployed
2. List any lint errors that must be fixed first
3. Identify migrations or config changes needed
4. Confirm the deployment is safe to proceed or flag blockers
