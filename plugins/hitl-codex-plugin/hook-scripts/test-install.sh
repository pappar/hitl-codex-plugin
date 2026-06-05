#!/usr/bin/env bash
# Regression tests for install.sh idempotency.
# Covers: AGENTS.md managed-block stability across repeated installs,
# and git hook backup preservation across repeated installs.
#
# Usage: bash hook-scripts/test-install.sh
# Run from the platform repo root or from an installed target repo.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_SCRIPT="$PLUGIN_ROOT/install.sh"

PASS=0
FAIL=0

assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  if [[ "$actual" == "$expected" ]]; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc (expected '$expected', got '$actual')"
    FAIL=$((FAIL + 1))
  fi
}

assert_contains() {
  local desc="$1" pattern="$2" file="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc (pattern '$pattern' not found in $file)"
    FAIL=$((FAIL + 1))
  fi
}

assert_not_contains() {
  local desc="$1" pattern="$2" file="$3"
  if ! grep -q "$pattern" "$file" 2>/dev/null; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc (pattern '$pattern' unexpectedly found in $file)"
    FAIL=$((FAIL + 1))
  fi
}

# ── Setup scratch repo ────────────────────────────────────────────────────────

TARGET=$(mktemp -d)
trap "rm -rf $TARGET" EXIT
git -C "$TARGET" init -q

echo ""
echo "=== AGENTS.md managed-block idempotency ==="
echo ""

# First install
bash "$INSTALL_SCRIPT" "$TARGET" > /dev/null 2>&1

BEGIN_COUNT=$(grep -c "HITL:MANAGED:BEGIN" "$TARGET/AGENTS.md" 2>/dev/null || echo 0)
END_COUNT=$(grep -c "HITL:MANAGED:END" "$TARGET/AGENTS.md" 2>/dev/null || echo 0)
HEADER_COUNT=$(grep -c "^# HITL Codex Instructions" "$TARGET/AGENTS.md" 2>/dev/null || echo 0)

assert_eq "First install: exactly one BEGIN marker" "1" "$BEGIN_COUNT"
assert_eq "First install: exactly one END marker" "1" "$END_COUNT"
assert_eq "First install: exactly one heading" "1" "$HEADER_COUNT"

# Second install (the upgrade path)
bash "$INSTALL_SCRIPT" "$TARGET" > /dev/null 2>&1

BEGIN_COUNT=$(grep -c "HITL:MANAGED:BEGIN" "$TARGET/AGENTS.md" 2>/dev/null || echo 0)
END_COUNT=$(grep -c "HITL:MANAGED:END" "$TARGET/AGENTS.md" 2>/dev/null || echo 0)
HEADER_COUNT=$(grep -c "^# HITL Codex Instructions" "$TARGET/AGENTS.md" 2>/dev/null || echo 0)

assert_eq "Second install: exactly one BEGIN marker (no nesting)" "1" "$BEGIN_COUNT"
assert_eq "Second install: exactly one END marker (no nesting)" "1" "$END_COUNT"
assert_eq "Second install: exactly one heading" "1" "$HEADER_COUNT"

# Custom content outside the block must be preserved across upgrades
echo "## My project conventions" >> "$TARGET/AGENTS.md"
bash "$INSTALL_SCRIPT" "$TARGET" > /dev/null 2>&1
assert_contains "Third install: custom content below block preserved" "My project conventions" "$TARGET/AGENTS.md"
assert_eq "Third install: still exactly one BEGIN marker" \
  "1" "$(grep -c "HITL:MANAGED:BEGIN" "$TARGET/AGENTS.md" 2>/dev/null || echo 0)"

echo ""
echo "=== Git hook backup preservation across repeated installs ==="
echo ""

TARGET2=$(mktemp -d)
trap "rm -rf $TARGET2" EXIT
git -C "$TARGET2" init -q

# Install a custom pre-commit hook before HITL
cat > "$TARGET2/.git/hooks/pre-commit" << 'HOOK'
#!/usr/bin/env bash
echo original-user-hook
HOOK
chmod +x "$TARGET2/.git/hooks/pre-commit"

# First install: should back up the original hook
bash "$INSTALL_SCRIPT" "$TARGET2" > /dev/null 2>&1
assert_contains "First install: backup contains original hook" \
  "original-user-hook" "$TARGET2/.git/hooks/pre-commit.hitl-backup"

# Second install (upgrade): backup must NOT be overwritten
bash "$INSTALL_SCRIPT" "$TARGET2" > /dev/null 2>&1
assert_contains "Second install: backup still contains original hook" \
  "original-user-hook" "$TARGET2/.git/hooks/pre-commit.hitl-backup"
assert_not_contains "Second install: backup does not contain HITL wrapper" \
  "exec bash" "$TARGET2/.git/hooks/pre-commit.hitl-backup"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
echo ""
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
