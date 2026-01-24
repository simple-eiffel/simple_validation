# S05 CONSTRAINTS - simple_validation

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## Technical Constraints

### Platform
- **Target OS**: Cross-platform
- **Compiler**: EiffelStudio 25.02+
- **Void Safety**: Required (full void-safe mode)

### Dependencies
- Gobo regexp library for pattern matching
- simple_mml for model-based contracts

### Regex Engine
- PCRE-compatible via RX_PCRE_REGULAR_EXPRESSION
- Patterns must be valid PCRE syntax

## Business Constraints

### Rule Ordering
- Rules are applied in registration order
- Order is preserved via MML_SEQUENCE model
- All rules are checked (no short-circuit)

### Error Collection
- All errors are collected, not just first
- Each rule can produce at most one error
- Error codes are fixed string constants

### Rule Types
| Code | Type | Description |
|------|------|-------------|
| 1 | required | Non-empty |
| 2 | min_length | Minimum characters |
| 3 | max_length | Maximum characters |
| 4 | min_value | Minimum numeric |
| 5 | max_value | Maximum numeric |
| 6 | pattern | Regex match |
| 7 | email | Email format |
| 8 | url | URL format |
| 9 | uuid | UUID format |
| 10 | alphanumeric | Letters/digits |
| 11 | numeric | Digits only |
| 12 | one_of | Enumeration |

## Performance Constraints

| Operation | Maximum Time |
|-----------|-------------|
| Rule addition | O(1) |
| Validate per rule | O(n) input length |
| Full validation | O(rules * input) |

## Validation Semantics

### Null Handling
- `validate(Void)` is valid (unless required rule)
- Empty string fails required rule

### Type Coercion
- Numeric rules accept INTEGER, REAL_64, REAL_32
- String rules accept STRING, READABLE_STRING_GENERAL
- All types support `.out` for string representation

### Pattern Matching
- Full string match required (anchored)
- Case-sensitive unless pattern specifies otherwise
