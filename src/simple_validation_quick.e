note
	description: "[
		Zero-configuration validation facade for beginners.

		One-liner validators that return BOOLEAN directly.
		For full control, use SIMPLE_VALIDATOR directly.

		X03 Contract Assault: Strengthened contracts.
		- Postconditions specify last_error semantics
		- Redundant /= Void preconditions removed (void safety)

		Quick Start Examples:
			create v.make

			-- One-liner validators
			if v.email ("user@example.com") then ...
			if v.url ("https://example.com") then ...
			if v.required (input) then ...
			if v.length_ok (input, 3, 20) then ...

			-- Get error message
			if not v.email (input) then
				print (v.last_error)
			end
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_VALIDATION_QUICK

create
	make

feature {NONE} -- Initialization

	make
			-- Create quick validation facade.
		do
			create validator.make
			create logger.make
			last_error := ""
		ensure
			validator_exists: attached validator
			logger_exists: attached logger
			no_errors: last_error.is_empty
			is_valid_initially: is_valid
		end

feature -- String Validators

	required (a_value: detachable STRING): BOOLEAN
			-- Is value non-empty?
		do
			if attached a_value as v and then not v.is_empty then
				Result := True
				last_error := ""
			else
				last_error := "Value is required"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = (attached a_value as v and then not v.is_empty)
		end

	not_blank (a_value: detachable STRING): BOOLEAN
			-- Is value non-empty after trimming whitespace?
		local
			l_trimmed: STRING
		do
			if attached a_value as v then
				l_trimmed := v.twin
				l_trimmed.left_adjust
				l_trimmed.right_adjust
				if not l_trimmed.is_empty then
					Result := True
					last_error := ""
				else
					last_error := "Value cannot be blank"
				end
			else
				last_error := "Value cannot be blank"
			end
		end

	min_length (a_value: STRING; a_min: INTEGER): BOOLEAN
			-- Is value at least min characters?
		require
			non_negative_min: a_min >= 0
		do
			if a_value.count >= a_min then
				Result := True
				last_error := ""
			else
				last_error := "Value must be at least " + a_min.out + " characters"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = (a_value.count >= a_min)
		end

	max_length (a_value: STRING; a_max: INTEGER): BOOLEAN
			-- Is value at most max characters?
		require
			non_negative_max: a_max >= 0
		do
			if a_value.count <= a_max then
				Result := True
				last_error := ""
			else
				last_error := "Value must be at most " + a_max.out + " characters"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = (a_value.count <= a_max)
		end

	length_ok (a_value: STRING; a_min, a_max: INTEGER): BOOLEAN
			-- Is value length between min and max (inclusive)?
		require
			valid_range: a_min <= a_max
		do
			if a_value.count >= a_min and a_value.count <= a_max then
				Result := True
				last_error := ""
			else
				last_error := "Value must be between " + a_min.out + " and " + a_max.out + " characters"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = (a_value.count >= a_min and a_value.count <= a_max)
		end

feature -- Format Validators

	email (a_value: STRING): BOOLEAN
			-- Is value a valid email format?
		local
			l_at_pos, l_dot_pos: INTEGER
		do
			-- Simple email validation: has @ and . after @
			l_at_pos := a_value.index_of ('@', 1)
			if l_at_pos > 1 and l_at_pos < a_value.count - 1 then
				l_dot_pos := a_value.index_of ('.', l_at_pos)
				if l_dot_pos > l_at_pos + 1 and l_dot_pos < a_value.count then
					Result := True
					last_error := ""
				else
					last_error := "Invalid email format"
				end
			else
				last_error := "Invalid email format"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
		end

	url (a_value: STRING): BOOLEAN
			-- Is value a valid URL format?
		do
			if a_value.starts_with ("http://") or a_value.starts_with ("https://") then
				if a_value.count > 10 then  -- At least "http://x.y"
					Result := True
					last_error := ""
				else
					last_error := "Invalid URL format"
				end
			else
				last_error := "URL must start with http:// or https://"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
		end

	alpha (a_value: STRING): BOOLEAN
			-- Does value contain only letters (A-Za-z)?
		local
			i: INTEGER
			c: CHARACTER
		do
			Result := not a_value.is_empty
			from i := 1 until i > a_value.count or not Result loop
				c := a_value.item (i)
				if not ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z')) then
					Result := False
				end
				i := i + 1
			end
			if Result then
				last_error := ""
			else
				last_error := "Value must contain only letters"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
		end

	alphanumeric (a_value: STRING): BOOLEAN
			-- Does value contain only letters and digits?
		local
			i: INTEGER
			c: CHARACTER
		do
			Result := not a_value.is_empty
			from i := 1 until i > a_value.count or not Result loop
				c := a_value.item (i)
				if not ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9')) then
					Result := False
				end
				i := i + 1
			end
			if Result then
				last_error := ""
			else
				last_error := "Value must contain only letters and numbers"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
		end

	numeric (a_value: STRING): BOOLEAN
			-- Does value contain only digits?
		local
			i: INTEGER
			c: CHARACTER
		do
			Result := not a_value.is_empty
			from i := 1 until i > a_value.count or not Result loop
				c := a_value.item (i)
				if not (c >= '0' and c <= '9') then
					Result := False
				end
				i := i + 1
			end
			if Result then
				last_error := ""
			else
				last_error := "Value must contain only numbers"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
		end

feature -- Numeric Validators

	is_integer (a_value: STRING): BOOLEAN
			-- Is value a valid integer?
		do
			Result := a_value.is_integer
			if Result then
				last_error := ""
			else
				last_error := "Value must be a valid integer"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = a_value.is_integer
		end

	is_number (a_value: STRING): BOOLEAN
			-- Is value a valid number (integer or decimal)?
		do
			Result := a_value.is_integer or a_value.is_real
			if Result then
				last_error := ""
			else
				last_error := "Value must be a valid number"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = (a_value.is_integer or a_value.is_real)
		end

	in_range (a_value: INTEGER; a_min, a_max: INTEGER): BOOLEAN
			-- Is integer value within range?
		require
			valid_range: a_min <= a_max
		do
			if a_value >= a_min and a_value <= a_max then
				Result := True
				last_error := ""
			else
				last_error := "Value must be between " + a_min.out + " and " + a_max.out
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = (a_value >= a_min and a_value <= a_max)
		end

	positive (a_value: INTEGER): BOOLEAN
			-- Is value positive (> 0)?
		do
			if a_value > 0 then
				Result := True
				last_error := ""
			else
				last_error := "Value must be positive"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = (a_value > 0)
		end

	non_negative (a_value: INTEGER): BOOLEAN
			-- Is value non-negative (>= 0)?
		do
			if a_value >= 0 then
				Result := True
				last_error := ""
			else
				last_error := "Value must not be negative"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = (a_value >= 0)
		end

feature -- Comparison Validators

	equals (a_value1, a_value2: STRING): BOOLEAN
			-- Do values match?
		do
			if a_value1.same_string (a_value2) then
				Result := True
				last_error := ""
			else
				last_error := "Values do not match"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
			definition: Result = a_value1.same_string (a_value2)
		end

	one_of (a_value: STRING; a_options: ARRAY [STRING]): BOOLEAN
			-- Is value one of the allowed options?
		require
			options_not_empty: a_options.count > 0
		do
			across a_options as ic_opt loop
				if a_value.same_string (ic_opt) then
					Result := True
				end
			end
			if Result then
				last_error := ""
			else
				last_error := "Value must be one of the allowed options"
			end
		ensure
			valid_has_no_error: Result implies last_error.is_empty
			invalid_has_error: not Result implies not last_error.is_empty
		end

feature -- Composite Validation

	validate_all (a_validations: ARRAY [TUPLE [name: STRING; valid: BOOLEAN; error: STRING]]): BOOLEAN
			-- Run multiple validations, collect all errors.
			-- Returns True only if all validations pass.
		local
			l_errors: ARRAYED_LIST [STRING]
		do
			create l_errors.make (a_validations.count)
			Result := True
			across a_validations as ic_v loop
				if not ic_v.valid then
					Result := False
					l_errors.extend (ic_v.name + ": " + ic_v.error)
				end
			end
			if l_errors.is_empty then
				last_error := ""
			else
				create last_error.make_empty
				across l_errors as ic_e loop
					if not last_error.is_empty then
						last_error.append ("; ")
					end
					last_error.append (ic_e)
				end
			end
		end

feature -- Status

	last_error: STRING
			-- Error message from last validation.

	is_valid: BOOLEAN
			-- Did last validation succeed?
		do
			Result := last_error.is_empty
		ensure
			definition: Result = last_error.is_empty
		end

feature -- Advanced Access

	validator: SIMPLE_VALIDATOR
			-- Access underlying validator for advanced operations.

feature {NONE} -- Implementation

	logger: SIMPLE_LOGGER
			-- Logger for debugging.

invariant
	validator_exists: attached validator
	logger_exists: attached logger
	last_error_exists: attached last_error
	validity_definition: is_valid = last_error.is_empty

end
