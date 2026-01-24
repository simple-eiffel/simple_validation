# S02 CLASS CATALOG - simple_validation

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## Class Hierarchy

```
SIMPLE_VALIDATOR
  - Main fluent validation builder
  - No inheritance

VALIDATION_RESULT
  - Validation result container
  - No inheritance

VALIDATION_ERROR
  - Single error details
  - No inheritance

SIMPLE_VALIDATION_QUICK
  - Zero-config facade
  - No inheritance
```

## Class Descriptions

### SIMPLE_VALIDATOR

**Purpose**: Fluent builder for composing validation rules

**Responsibilities**:
- Build validation rule chains
- Execute validation against values
- Collect and report errors
- Support model-based specification (MML)

**Key Features**:
- `required`, `min_length`, `max_length`: Basic rules
- `email`, `url`, `uuid`: Format validators
- `min_value`, `max_value`: Numeric rules
- `pattern`: Custom regex
- `one_of`: Enumeration
- `validate`: Execute all rules
- `model_rules`: MML_SEQUENCE representation

### VALIDATION_RESULT

**Purpose**: Container for validation outcome and errors

**Responsibilities**:
- Track validity status
- Collect multiple errors
- Provide error access and iteration
- Support merging results

**Key Features**:
- `is_valid`: Overall status
- `errors`: Error collection
- `add_error`: Append error
- `merge`: Combine results
- `model_error_codes`: MML_SET representation

### VALIDATION_ERROR

**Purpose**: Single validation error with full context

**Responsibilities**:
- Store error code and message
- Track field name
- Record constraint and actual value

**Key Attributes**:
- `code`: Error type (e.g., "required", "min_length")
- `message`: Human-readable description
- `field_name`: Associated field
- `constraint`: The violated constraint
- `actual_value`: What was provided

### SIMPLE_VALIDATION_QUICK

**Purpose**: Zero-configuration validation for simple cases

**Responsibilities**:
- Provide one-liner validators
- Track last error message
- Wrap SIMPLE_VALIDATOR for advanced needs

**Key Features**:
- `required`, `email`, `url`: Quick validators returning BOOLEAN
- `min_length`, `max_length`, `length_ok`: Length checks
- `is_integer`, `is_number`, `in_range`: Numeric checks
- `last_error`: Error from last check
