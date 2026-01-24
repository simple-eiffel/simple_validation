# 7S-04 SIMPLE-STAR - simple_validation

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## Ecosystem Dependencies

### Required Libraries
| Library | Purpose | Usage |
|---------|---------|-------|
| simple_mml | Model contracts | MML_SEQUENCE, MML_SET for specs |
| simple_logger | Logging | Debug output in quick facade |

### Standard Library
| Component | Purpose |
|-----------|---------|
| ARRAYED_LIST | Store rules and errors |
| TUPLE | Rule storage (type + constraint) |
| INTEGER_REF | Box integer constraints |
| REAL_64_REF | Box numeric constraints |

### Gobo Libraries
| Component | Purpose |
|-----------|---------|
| RX_PCRE_REGULAR_EXPRESSION | Pattern matching |

## Integration Points

### Fluent Validation
```eiffel
create validator.make
result := validator.required.min_length(3).email.validate(input)
if not result.is_valid then
    across result.errors as e loop
        print (e.full_message)
    end
end
```

### Quick Validation
```eiffel
create v.make
if v.email ("user@example.com") then ...
if not v.required (input) then print (v.last_error) end
```

## Ecosystem Position

simple_validation provides input validation for:
- simple_web: Request parameter validation
- Form processing applications
- Data import/export tools
- API request validation
