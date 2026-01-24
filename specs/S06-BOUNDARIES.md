# S06 BOUNDARIES - simple_validation

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## System Boundaries

```
+--------------------------------------------------+
|                    Client Code                    |
+--------------------------------------------------+
          |                          |
          v                          v
+--------------------+    +------------------------+
| SIMPLE_VALIDATOR   |    | SIMPLE_VALIDATION_QUICK|
| (Fluent Builder)   |    | (One-liners)           |
+--------------------+    +------------------------+
          |                          |
          v                          v
+--------------------------------------------------+
|                 VALIDATION_RESULT                 |
|     +---------------------------------------+     |
|     |          VALIDATION_ERROR(s)          |     |
|     +---------------------------------------+     |
+--------------------------------------------------+
          |
          v
+--------------------------------------------------+
|              RX_PCRE_REGULAR_EXPRESSION           |
|                  (Gobo Regexp)                    |
+--------------------------------------------------+
```

## Interface Boundaries

### Public Interface (SIMPLE_VALIDATOR)
- Rule builders: `required`, `min_length`, `email`, etc.
- Execution: `validate`, `is_valid`
- Configuration: `with_message`, `with_field_name`

### Public Interface (SIMPLE_VALIDATION_QUICK)
- Direct validators: `email()`, `url()`, `required()`, etc.
- Status: `last_error`, `is_valid`
- Escape hatch: `validator`

### Internal Interface
- Rule storage: TUPLE [rule_type: INTEGER; constraint: ANY]
- Rule execution: `validate_rule` (private)
- Pattern constants: `Email_pattern`, `Url_pattern`, `Uuid_pattern`

## Data Boundaries

### Input Data
| Data | Source | Validation |
|------|--------|------------|
| Values to validate | Client | Type-flexible |
| Constraints | Client | Preconditions |
| Custom patterns | Client | Regex compile |

### Output Data
| Data | Destination | Format |
|------|-------------|--------|
| VALIDATION_RESULT | Client | Object |
| BOOLEAN | Client (quick) | Primitive |
| Error messages | Client | STRING |

## Trust Boundaries

| Zone | Trust Level | Validation |
|------|-------------|------------|
| Input values | Untrusted | Full validation |
| Constraints | Trusted | Preconditions |
| Custom patterns | Semi-trusted | Regex compile |
| Error messages | Trusted | Internal |
