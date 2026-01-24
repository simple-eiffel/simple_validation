# S04 FEATURE SPECS - simple_validation

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## SIMPLE_VALIDATOR Features

### Rule Builders (Return Current for chaining)

| Feature | Signature | Description |
|---------|-----------|-------------|
| required | : SIMPLE_VALIDATOR | Non-empty rule |
| min_length | (INTEGER): SIMPLE_VALIDATOR | Minimum length |
| max_length | (INTEGER): SIMPLE_VALIDATOR | Maximum length |
| length_between | (INTEGER, INTEGER): SIMPLE_VALIDATOR | Range (convenience) |
| min_value | (REAL_64): SIMPLE_VALIDATOR | Minimum numeric value |
| max_value | (REAL_64): SIMPLE_VALIDATOR | Maximum numeric value |
| value_between | (REAL_64, REAL_64): SIMPLE_VALIDATOR | Numeric range |
| pattern | (STRING): SIMPLE_VALIDATOR | Custom regex |
| email | : SIMPLE_VALIDATOR | Email format |
| url | : SIMPLE_VALIDATOR | URL format |
| uuid | : SIMPLE_VALIDATOR | UUID format |
| alphanumeric | : SIMPLE_VALIDATOR | Letters/digits only |
| numeric | : SIMPLE_VALIDATOR | Digits only |
| one_of | (ARRAY [STRING]): SIMPLE_VALIDATOR | Enumeration |
| with_message | (STRING): SIMPLE_VALIDATOR | Custom error message |
| with_field_name | (STRING): SIMPLE_VALIDATOR | Field name for errors |

### Execution

| Feature | Signature | Description |
|---------|-----------|-------------|
| validate | (ANY): VALIDATION_RESULT | Run all rules |
| is_valid | (ANY): BOOLEAN | Quick validity check |

### Model Queries

| Feature | Signature | Description |
|---------|-----------|-------------|
| model_rules | MML_SEQUENCE [...] | Rules as MML sequence |
| model_rule_count | INTEGER | Rule count |

## VALIDATION_RESULT Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| is_valid | BOOLEAN | Overall validity |
| has_errors | BOOLEAN | Any errors? |
| errors | ARRAYED_LIST [VALIDATION_ERROR] | All errors |
| first_error | detachable VALIDATION_ERROR | First error |
| error_messages | ARRAYED_LIST [STRING] | Message list |
| error_count | INTEGER | Number of errors |
| add_error | (VALIDATION_ERROR) | Append error |
| merge | (VALIDATION_RESULT) | Combine results |
| model_error_codes | MML_SET [STRING] | Codes as MML set |

## VALIDATION_ERROR Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| code | STRING | Error code |
| message | STRING | Human message |
| field_name | STRING | Associated field |
| constraint | detachable ANY | Violated constraint |
| actual_value | detachable ANY | Provided value |
| full_message | STRING | Field + message |
| set_field_name | (STRING) | Set field |
| set_constraint | (ANY) | Set constraint |
| set_actual_value | (ANY) | Set actual |

## SIMPLE_VALIDATION_QUICK Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| required | (STRING): BOOLEAN | Non-empty check |
| email | (STRING): BOOLEAN | Email format |
| url | (STRING): BOOLEAN | URL format |
| alpha | (STRING): BOOLEAN | Letters only |
| alphanumeric | (STRING): BOOLEAN | Letters/digits |
| numeric | (STRING): BOOLEAN | Digits only |
| min_length | (STRING, INTEGER): BOOLEAN | Min length |
| max_length | (STRING, INTEGER): BOOLEAN | Max length |
| length_ok | (STRING, INTEGER, INTEGER): BOOLEAN | Length range |
| is_integer | (STRING): BOOLEAN | Valid integer |
| is_number | (STRING): BOOLEAN | Valid number |
| in_range | (INTEGER, INTEGER, INTEGER): BOOLEAN | Integer range |
| positive | (INTEGER): BOOLEAN | > 0 |
| non_negative | (INTEGER): BOOLEAN | >= 0 |
| equals | (STRING, STRING): BOOLEAN | Strings match |
| one_of | (STRING, ARRAY [STRING]): BOOLEAN | In list |
| last_error | STRING | Last error message |
| is_valid | BOOLEAN | Last check passed |
| validator | SIMPLE_VALIDATOR | Access advanced |
