#!/bin/bash
echo "Триггер workflow..."
git commit --allow-empty -m "Trigger: GitHub Actions workflow execution"
git push origin homework/cicd-deploy
echo "✅ Workflow триггернут. Проверьте GitHub Actions через 30 секунд."
