# simple_validation

Fluent data validation library for Eiffel with chainable rules inspired by HTML5 Constraint Validation API and JSON Schema.

## Features

- **Fluent API**: Chain validation rules naturally
- **HTML5 Constraints**: Required, min/max length, pattern matching
- **Numeric Validation**: Min/max values, integer checks
- **Format Validation**: Email, URL patterns
- **Custom Rules**: Add your own validation logic
- **Rich Error Messages**: Detailed error information with field names

## Installation

Add to your ECF file:

```xml
<library name="simple_validation" location="$SIMPLE_VALIDATION/simple_validation.ecf"/>
```

Set the environment variable:
```
export SIMPLE_VALIDATION=/path/to/simple_validation
```

## Quick Start

```eiffel
local
    validator: SIMPLE_VALIDATOR
    result: VALIDATION_RESULT
do
    create validator.make

    -- Validate an email
    result := validator.required.email.for_field ("email").validate ("user@example.com")

    if result.is_valid then
        io.put_string ("Valid!%N")
    else
        io.put_string (result.to_string)
    end
end
```

## API Reference

### String Validation

```eiffel
-- Required (non-empty)
validator.required

-- Length constraints
validator.min_length (5)
validator.max_length (100)
validator.length_between (5, 100)

-- Pattern matching
validator.pattern ("^[A-Z]+$")

-- Predefined formats
validator.email
validator.url
validator.alpha
validator.alpha_numeric
```

### Numeric Validation

```eiffel
-- Value constraints
validator.min_value (0.0)
validator.max_value (100.0)
validator.value_between (0.0, 100.0)

-- Integer check
validator.is_integer
```

### Custom Messages

```eiffel
validator.required.with_message ("This field cannot be empty")
```

### Field Names

```eiffel
-- Adds field name to error messages
validator.required.for_field ("username")
```

### Custom Rules

```eiffel
validator.custom (agent my_validation_function)

my_validation_function (value: STRING): BOOLEAN
    do
        Result := value.count > 3 and value.starts_with ("user_")
    end
```

## Validation Result

```eiffel
result: VALIDATION_RESULT

-- Check validity
if result.is_valid then ... end
if result.has_errors then ... end

-- Access errors
across result.errors as err loop
    io.put_string (err.full_message + "%N")
end

-- Merge results
result.merge (other_result)
```

## Error Structure

Each `VALIDATION_ERROR` contains:
- `code`: Error type (e.g., "required", "min_length")
- `message`: Human-readable message
- `field_name`: Optional field name
- `constraint`: The constraint that failed
- `actual_value`: The value that failed validation

## Example: Form Validation

```eiffel
validate_user_form (username, email, age: STRING): VALIDATION_RESULT
    local
        v1, v2, v3: SIMPLE_VALIDATOR
        r1, r2, r3: VALIDATION_RESULT
    do
        create Result.make_valid

        -- Username: 3-20 chars, alphanumeric
        create v1.make
        r1 := v1.required.length_between (3, 20).alpha_numeric
            .for_field ("username").validate (username)
        Result.merge (r1)

        -- Email: required, valid format
        create v2.make
        r2 := v2.required.email.for_field ("email").validate (email)
        Result.merge (r2)

        -- Age: required, integer, 18-120
        create v3.make
        r3 := v3.required.is_integer.value_between (18.0, 120.0)
            .for_field ("age").validate (age)
        Result.merge (r3)
    end
```

## Tests

Run the test suite:
```bash
ec -config simple_validation.ecf -target simple_validation_tests -c_compile
./EIFGENs/simple_validation_tests/W_code/simple_validation.exe
```

**49 tests** covering all validation rules and error handling.

## Dependencies

- EiffelBase
- Gobo Regexp (for pattern matching)
- testing_ext (for tests)

## License

MIT License - See LICENSE file for details.

## Author

Larry Rix
