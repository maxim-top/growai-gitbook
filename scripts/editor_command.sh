# 1. select drafts to present directory
sed 's/.*(\(.*\).*)/mv "\1" "." /' articles | bash

# 2. remove index path for selected files
cat SUMMARY.md.bak | awk -F'/' '{print substr($1, 1, length($1)-2)$3}' > SUMMARY.md
