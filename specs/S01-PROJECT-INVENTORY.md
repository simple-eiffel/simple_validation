# S01 PROJECT INVENTORY - simple_validation

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## Project Structure

```
simple_validation/
  simple_validation.ecf     # Eiffel configuration file
  src/
    simple_validator.e      # Main fluent validator
    validation_result.e     # Result aggregation
    validation_error.e      # Single error details
    simple_validation_quick.e # Quick one-liner facade
  testing/
    test_app.e              # Test application entry
    lib_tests.e             # Test cases
  research/                 # 7S research documents
  specs/                    # Specification documents
```

## Source Files

| File | Type | Lines | Description |
|------|------|-------|-------------|
| simple_validator.e | Class | ~650 | Fluent validation builder |
| validation_result.e | Class | ~175 | Result with error collection |
| validation_error.e | Class | ~110 | Single error with details |
| simple_validation_quick.e | Class | ~430 | Zero-config facade |

## Test Files

| File | Type | Tests | Description |
|------|------|-------|-------------|
| test_app.e | Root | - | Test application entry point |
| lib_tests.e | Tests | TBD | Library test cases |

## Dependencies

### Internal (simple_* ecosystem)
- simple_mml (MML_SEQUENCE, MML_SET)
- simple_logger (Debug logging)

### External (Gobo)
- regexp (RX_PCRE_REGULAR_EXPRESSION)

### External (EiffelStudio)
- base (ARRAYED_LIST, TUPLE, INTEGER_REF, REAL_64_REF)

## Build Targets

| Target | Type | Description |
|--------|------|-------------|
| simple_validation | Library | Main library target |
| simple_validation_tests | Executable | Test runner |
