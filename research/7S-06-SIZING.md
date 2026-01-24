# 7S-06 SIZING - simple_validation


**Date**: 2026-01-23

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## Codebase Metrics

### Source Files
| File | Lines | Purpose |
|------|-------|---------|
| simple_validator.e | ~650 | Main fluent validator |
| validation_result.e | ~175 | Result aggregation |
| validation_error.e | ~110 | Single error details |
| simple_validation_quick.e | ~430 | Quick facade |
| **Total** | ~1365 | |

### Class Count
- 4 production classes
- 2 test classes (test_app.e, lib_tests.e)

## Complexity Analysis

### SIMPLE_VALIDATOR
- Features: ~35
- Cyclomatic complexity: High (12 rule types)
- Key complexity: Rule dispatch in validate_rule

### VALIDATION_RESULT
- Features: ~12
- Cyclomatic complexity: Low
- Simple aggregation pattern

### VALIDATION_ERROR
- Features: ~8
- Cyclomatic complexity: Very Low
- Pure data class

### SIMPLE_VALIDATION_QUICK
- Features: ~20
- Cyclomatic complexity: Low-Medium
- Thin wrapper over SIMPLE_VALIDATOR

## Memory Footprint

| Component | Typical Size |
|-----------|-------------|
| SIMPLE_VALIDATOR | ~100 bytes + rules |
| Per rule | ~50 bytes |
| VALIDATION_RESULT | ~80 bytes + errors |
| VALIDATION_ERROR | ~100 bytes |

## Performance Characteristics

| Operation | Expected Time |
|-----------|--------------|
| Add rule | O(1) |
| Validate (per rule) | O(n) where n = input length |
| Regex validation | O(n) typical |
| Full validation | O(rules * input) |
