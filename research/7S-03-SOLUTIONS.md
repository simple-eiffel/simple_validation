# 7S-03 SOLUTIONS - simple_validation

**BACKWASH** - Generated: 2026-01-23
**Library**: simple_validation

## Alternative Approaches Considered

### 1. Static Validation Functions
**Description**: Module of standalone validation functions
**Pros**: Simple, no state
**Cons**: No composition, verbose multi-rule validation
**Decision**: Rejected - poor ergonomics

### 2. Validation Annotation System
**Description**: Annotate class features with validation metadata
**Pros**: Declarative, clean
**Cons**: Requires language/compiler support not available
**Decision**: Not feasible in Eiffel

### 3. Fluent Builder Pattern (Selected)
**Description**: Chainable methods returning Current
**Pros**: Clean API, composable, readable
**Cons**: Slightly more complex implementation
**Decision**: Selected - best Eiffel idiom

### 4. Strategy Pattern per Rule
**Description**: Each rule as separate VALIDATOR class
**Pros**: Highly extensible
**Cons**: Many small classes, complex setup
**Decision**: Partial - rules are encoded as integers, not classes

## Implementation Strategy

1. SIMPLE_VALIDATOR: Main fluent builder
2. VALIDATION_RESULT: Aggregates errors
3. VALIDATION_ERROR: Single error with details
4. SIMPLE_VALIDATION_QUICK: Zero-config facade

## Technology Stack

- **gobo regexp**: PCRE regular expressions (RX_PCRE_REGULAR_EXPRESSION)
- **simple_mml**: Model-based contracts
- **simple_logger**: Debug logging
