# S03 CONTRACTS - simple_validation

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## SIMPLE_VALIDATOR Contracts

### make
```eiffel
make
    ensure
        no_rules: rules.is_empty
        no_field_name: field_name.is_empty
        no_custom_message: custom_message.is_empty
```

### required
```eiffel
required: SIMPLE_VALIDATOR
    ensure
        rule_added: rules.count = old rules.count + 1
        rule_appended: rules.last.rule_type = Rule_required
        model_extended: model_rules.count = old model_rules.count + 1
        returns_self: Result = Current
```

### min_length
```eiffel
min_length (n: INTEGER): SIMPLE_VALIDATOR
    require
        non_negative: n >= 0
    ensure
        rule_added: rules.count = old rules.count + 1
        constraint_recorded: attached {INTEGER_REF} rules.last.constraint as ref implies ref.item = n
        returns_self: Result = Current
```

### validate
```eiffel
validate (value: detachable ANY): VALIDATION_RESULT
    ensure
        valid_if_no_errors: Result.is_valid = (Result.error_count = 0)
        all_rules_applied: True
```

## VALIDATION_RESULT Contracts

### make_valid
```eiffel
make_valid
    ensure
        is_valid: is_valid
        no_errors: errors.is_empty
```

### make_invalid
```eiffel
make_invalid (a_error: VALIDATION_ERROR)
    ensure
        not_valid: not is_valid
        has_error: errors.count = 1
        error_recorded: errors.has (a_error)
        model_has_error: model_error_codes.has (a_error.code)
```

### add_error
```eiffel
add_error (a_error: VALIDATION_ERROR)
    ensure
        error_added: errors.has (a_error)
        not_valid: not is_valid
        count_increased: errors.count = old errors.count + 1
```

## VALIDATION_ERROR Contracts

### make
```eiffel
make (a_code: STRING; a_message: STRING)
    require
        code_not_empty: not a_code.is_empty
        message_not_empty: not a_message.is_empty
    ensure
        code_set: code.same_string (a_code)
        message_set: message.same_string (a_message)
```

## Class Invariants

### SIMPLE_VALIDATOR
```eiffel
invariant
    rules_exist: attached rules
    model_consistent: model_rules.count = rules.count
    valid_rule_types: across rules as ic all
        ic.rule_type >= Rule_required and ic.rule_type <= Rule_one_of
    end
```

### VALIDATION_RESULT
```eiffel
invariant
    errors_exist: attached errors
    valid_implies_no_errors: is_valid implies errors.is_empty
    errors_implies_invalid: not errors.is_empty implies not is_valid
    model_consistent: model_error_count = errors.count
```

### VALIDATION_ERROR
```eiffel
invariant
    code_exists: attached code
    code_not_empty: not code.is_empty
    message_exists: attached message
    message_not_empty: not message.is_empty
```
