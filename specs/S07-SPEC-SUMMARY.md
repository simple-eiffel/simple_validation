# S07 SPEC SUMMARY - simple_validation

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## Executive Summary

simple_validation provides fluent, chainable data validation with comprehensive rule support and model-based specifications. Two APIs: detailed (SIMPLE_VALIDATOR) and quick (SIMPLE_VALIDATION_QUICK).

## Key Specifications

### Classes
| Class | Purpose | Complexity |
|-------|---------|------------|
| SIMPLE_VALIDATOR | Fluent builder | High |
| VALIDATION_RESULT | Result container | Low |
| VALIDATION_ERROR | Error details | Low |
| SIMPLE_VALIDATION_QUICK | Quick facade | Medium |

### Features by Category
| Category | Count | Key Features |
|----------|-------|--------------|
| Rule builders | 15 | required, min_length, email, etc. |
| Execution | 2 | validate, is_valid |
| Configuration | 2 | with_message, with_field_name |
| Model queries | 2 | model_rules, model_rule_count |

### Contract Coverage
| Contract Type | Count |
|--------------|-------|
| Preconditions | 25+ |
| Postconditions | 35+ |
| Invariants | 10+ |

## Dependencies

### Required
- simple_mml (Model-based contracts)
- simple_logger (Debugging)
- gobo regexp (Pattern matching)

### Optional
- None

## Quality Metrics

| Metric | Value |
|--------|-------|
| Source lines | ~1365 |
| Classes | 4 |
| Features | ~70 |
| Test coverage | Present |

## API Summary

```eiffel
-- Fluent validation
create v.make
result := v.required.min_length(3).max_length(50).email.validate(input)
if not result.is_valid then
    print (result.first_error.full_message)
end

-- Quick validation
create q.make
if q.email (input) and q.length_ok (input, 5, 100) then
    -- valid
else
    print (q.last_error)
end
```

## Status

**Phase**: 4 (API Documentation)
**Stability**: Stable
**Production Ready**: Yes
