note
	description: "Fluent data validation with chainable rules"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_VALIDATOR

create
	make

feature {NONE} -- Initialization

	make
			-- Create a new validator with no rules.
		do
			create rules.make (5)
			create field_name.make_empty
			create custom_message.make_empty
		ensure
			no_rules: rules.is_empty
			no_field_name: field_name.is_empty
			no_custom_message: custom_message.is_empty
		end

feature -- Access

	field_name: STRING
			-- Name of field being validated.

	custom_message: STRING
			-- Custom error message to use instead of default.

feature -- Fluent Configuration: Required

	required: SIMPLE_VALIDATOR
			-- Add required (non-empty) rule.
		do
			rules.extend ([Rule_required, Void])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

feature -- Fluent Configuration: Length

	min_length (n: INTEGER): SIMPLE_VALIDATOR
			-- Add minimum length rule.
		require
			positive: n >= 0
		local
			l_ref: INTEGER_REF
		do
			create l_ref
			l_ref.set_item (n)
			rules.extend ([Rule_min_length, l_ref])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

	max_length (n: INTEGER): SIMPLE_VALIDATOR
			-- Add maximum length rule.
		require
			positive: n >= 0
		local
			l_ref: INTEGER_REF
		do
			create l_ref
			l_ref.set_item (n)
			rules.extend ([Rule_max_length, l_ref])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

	length_between (min, max: INTEGER): SIMPLE_VALIDATOR
			-- Add length range rule.
		require
			min_positive: min >= 0
			max_positive: max >= 0
			valid_range: min <= max
		do
			Result := min_length (min).max_length (max)
		ensure
			rules_added: rules.count = old rules.count + 2
			returns_self: Result = Current
		end

feature -- Fluent Configuration: Numeric

	min_value (n: REAL_64): SIMPLE_VALIDATOR
			-- Add minimum value rule.
		local
			l_ref: REAL_64_REF
		do
			create l_ref
			l_ref.set_item (n)
			rules.extend ([Rule_min_value, l_ref])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

	max_value (n: REAL_64): SIMPLE_VALIDATOR
			-- Add maximum value rule.
		local
			l_ref: REAL_64_REF
		do
			create l_ref
			l_ref.set_item (n)
			rules.extend ([Rule_max_value, l_ref])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

	value_between (min, max: REAL_64): SIMPLE_VALIDATOR
			-- Add value range rule.
		require
			valid_range: min <= max
		do
			Result := min_value (min).max_value (max)
		ensure
			rules_added: rules.count = old rules.count + 2
			returns_self: Result = Current
		end

feature -- Fluent Configuration: Pattern

	pattern (regex: STRING): SIMPLE_VALIDATOR
			-- Add regex pattern rule.
		require
			regex_not_void: regex /= Void
			regex_not_empty: not regex.is_empty
		do
			rules.extend ([Rule_pattern, regex])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

	email: SIMPLE_VALIDATOR
			-- Add email format rule.
		do
			rules.extend ([Rule_email, Void])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

	url: SIMPLE_VALIDATOR
			-- Add URL format rule.
		do
			rules.extend ([Rule_url, Void])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

	uuid: SIMPLE_VALIDATOR
			-- Add UUID format rule.
		do
			rules.extend ([Rule_uuid, Void])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

	alphanumeric: SIMPLE_VALIDATOR
			-- Add alphanumeric-only rule.
		do
			rules.extend ([Rule_alphanumeric, Void])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

	numeric: SIMPLE_VALIDATOR
			-- Add numeric-only rule (digits only).
		do
			rules.extend ([Rule_numeric, Void])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

feature -- Fluent Configuration: Choices

	one_of (values: ARRAY [STRING]): SIMPLE_VALIDATOR
			-- Add enumeration rule (value must be one of given values).
		require
			values_not_void: values /= Void
			values_not_empty: not values.is_empty
		do
			rules.extend ([Rule_one_of, values])
			Result := Current
		ensure
			rule_added: rules.count = old rules.count + 1
			returns_self: Result = Current
		end

feature -- Fluent Configuration: Customization

	with_message (msg: STRING): SIMPLE_VALIDATOR
			-- Set custom error message.
		require
			msg_not_void: msg /= Void
			msg_not_empty: not msg.is_empty
		do
			custom_message := msg
			Result := Current
		ensure
			message_set: custom_message.same_string (msg)
			returns_self: Result = Current
		end

	with_field_name (name: STRING): SIMPLE_VALIDATOR
			-- Set field name for error messages.
		require
			name_not_void: name /= Void
		do
			field_name := name
			Result := Current
		ensure
			field_name_set: field_name.same_string (name)
			returns_self: Result = Current
		end

feature -- Validation

	validate (value: detachable ANY): VALIDATION_RESULT
			-- Validate `value` against all rules.
		local
			l_error: detachable VALIDATION_ERROR
			l_rule: TUPLE [rule_type: INTEGER; constraint: detachable ANY]
		do
			create Result.make_valid
			across rules as rule loop
				l_rule := rule
				l_error := validate_rule (l_rule.rule_type, l_rule.constraint, value)
				if l_error /= Void then
					if not field_name.is_empty then
						l_error.set_field_name (field_name)
					end
					Result.add_error (l_error)
				end
			end
		ensure
			result_not_void: Result /= Void
		end

	is_valid (value: detachable ANY): BOOLEAN
			-- Does `value` pass all validation rules?
		do
			Result := validate (value).is_valid
		end

feature {NONE} -- Implementation

	rules: ARRAYED_LIST [TUPLE [rule_type: INTEGER; constraint: detachable ANY]]
			-- List of validation rules to apply.

	validate_rule (rule_type: INTEGER; constraint: detachable ANY; value: detachable ANY): detachable VALIDATION_ERROR
			-- Validate single rule, return error if failed.
		local
			str_value: detachable STRING
			num_value: REAL_64
			is_numeric_value: BOOLEAN
		do
			-- Extract string representation
			if attached {STRING} value as s then
				str_value := s
			elseif attached {READABLE_STRING_GENERAL} value as rs then
				str_value := rs.to_string_8
			elseif value /= Void then
				str_value := value.out
			end

			-- Extract numeric value if applicable
			if attached {INTEGER} value as i then
				num_value := i.to_double
				is_numeric_value := True
			elseif attached {REAL_64} value as r then
				num_value := r
				is_numeric_value := True
			elseif attached {REAL_32} value as r32 then
				num_value := r32.to_double
				is_numeric_value := True
			elseif str_value /= Void and then str_value.is_real_64 then
				num_value := str_value.to_real_64
				is_numeric_value := True
			end

			inspect rule_type
			when Rule_required then
				Result := validate_required (str_value, value)
			when Rule_min_length then
				if attached {INTEGER_REF} constraint as min_len then
					Result := validate_min_length (str_value, min_len.item)
				end
			when Rule_max_length then
				if attached {INTEGER_REF} constraint as max_len then
					Result := validate_max_length (str_value, max_len.item)
				end
			when Rule_min_value then
				if attached {REAL_64_REF} constraint as min_val and is_numeric_value then
					Result := validate_min_value (num_value, min_val.item)
				end
			when Rule_max_value then
				if attached {REAL_64_REF} constraint as max_val and is_numeric_value then
					Result := validate_max_value (num_value, max_val.item)
				end
			when Rule_pattern then
				if attached {STRING} constraint as regex then
					Result := validate_pattern (str_value, regex)
				end
			when Rule_email then
				Result := validate_email (str_value)
			when Rule_url then
				Result := validate_url (str_value)
			when Rule_uuid then
				Result := validate_uuid (str_value)
			when Rule_alphanumeric then
				Result := validate_alphanumeric (str_value)
			when Rule_numeric then
				Result := validate_numeric (str_value)
			when Rule_one_of then
				if attached {ARRAY [STRING]} constraint as choices then
					Result := validate_one_of (str_value, choices)
				end
			else
				-- Unknown rule type, ignore
			end

			-- Apply custom message if set
			if Result /= Void and not custom_message.is_empty then
				create Result.make (Result.code, custom_message)
			end
		end

feature {NONE} -- Rule Validators

	validate_required (str_value: detachable STRING; raw_value: detachable ANY): detachable VALIDATION_ERROR
			-- Validate required rule.
		do
			if raw_value = Void then
				create Result.make ("required", "This field is required")
			elseif str_value /= Void and then str_value.is_empty then
				create Result.make ("required", "This field is required")
			end
		end

	validate_min_length (str_value: detachable STRING; min_len: INTEGER): detachable VALIDATION_ERROR
			-- Validate minimum length rule.
		do
			if str_value /= Void and then str_value.count < min_len then
				create Result.make ("min_length", "Must be at least " + min_len.out + " characters")
				Result.set_constraint (min_len)
				Result.set_actual_value (str_value.count)
			end
		end

	validate_max_length (str_value: detachable STRING; max_len: INTEGER): detachable VALIDATION_ERROR
			-- Validate maximum length rule.
		do
			if str_value /= Void and then str_value.count > max_len then
				create Result.make ("max_length", "Must be at most " + max_len.out + " characters")
				Result.set_constraint (max_len)
				Result.set_actual_value (str_value.count)
			end
		end

	validate_min_value (num_value: REAL_64; min_val: REAL_64): detachable VALIDATION_ERROR
			-- Validate minimum value rule.
		do
			if num_value < min_val then
				create Result.make ("min_value", "Must be at least " + min_val.out)
				Result.set_constraint (min_val)
				Result.set_actual_value (num_value)
			end
		end

	validate_max_value (num_value: REAL_64; max_val: REAL_64): detachable VALIDATION_ERROR
			-- Validate maximum value rule.
		do
			if num_value > max_val then
				create Result.make ("max_value", "Must be at most " + max_val.out)
				Result.set_constraint (max_val)
				Result.set_actual_value (num_value)
			end
		end

	validate_pattern (str_value: detachable STRING; regex: STRING): detachable VALIDATION_ERROR
			-- Validate pattern rule using regex.
		local
			l_regex: RX_PCRE_REGULAR_EXPRESSION
		do
			if str_value /= Void then
				create l_regex.make
				l_regex.compile (regex)
				if l_regex.is_compiled then
					l_regex.match (str_value)
					if not l_regex.has_matched then
						create Result.make ("pattern", "Does not match required pattern")
						Result.set_constraint (regex)
						Result.set_actual_value (str_value)
					end
				end
			end
		end

	validate_email (str_value: detachable STRING): detachable VALIDATION_ERROR
			-- Validate email format.
		local
			l_regex: RX_PCRE_REGULAR_EXPRESSION
		do
			if str_value /= Void and then not str_value.is_empty then
				create l_regex.make
				l_regex.compile (Email_pattern)
				if l_regex.is_compiled then
					l_regex.match (str_value)
					if not l_regex.has_matched then
						create Result.make ("email", "Must be a valid email address (e.g., user@example.com)")
						Result.set_actual_value (str_value)
					end
				end
			end
		end

	validate_url (str_value: detachable STRING): detachable VALIDATION_ERROR
			-- Validate URL format.
		local
			l_regex: RX_PCRE_REGULAR_EXPRESSION
		do
			if str_value /= Void and then not str_value.is_empty then
				create l_regex.make
				l_regex.compile (Url_pattern)
				if l_regex.is_compiled then
					l_regex.match (str_value)
					if not l_regex.has_matched then
						create Result.make ("url", "Must be a valid URL (e.g., https://example.com)")
						Result.set_actual_value (str_value)
					end
				end
			end
		end

	validate_uuid (str_value: detachable STRING): detachable VALIDATION_ERROR
			-- Validate UUID format.
		local
			l_regex: RX_PCRE_REGULAR_EXPRESSION
		do
			if str_value /= Void and then not str_value.is_empty then
				create l_regex.make
				l_regex.compile (Uuid_pattern)
				if l_regex.is_compiled then
					l_regex.match (str_value)
					if not l_regex.has_matched then
						create Result.make ("uuid", "Must be a valid UUID (e.g., 550e8400-e29b-41d4-a716-446655440000)")
						Result.set_actual_value (str_value)
					end
				end
			end
		end

	validate_alphanumeric (str_value: detachable STRING): detachable VALIDATION_ERROR
			-- Validate alphanumeric only.
		local
			l_regex: RX_PCRE_REGULAR_EXPRESSION
		do
			if str_value /= Void and then not str_value.is_empty then
				create l_regex.make
				l_regex.compile ("^[a-zA-Z0-9]+$")
				if l_regex.is_compiled then
					l_regex.match (str_value)
					if not l_regex.has_matched then
						create Result.make ("alphanumeric", "Must contain only letters and numbers")
						Result.set_actual_value (str_value)
					end
				end
			end
		end

	validate_numeric (str_value: detachable STRING): detachable VALIDATION_ERROR
			-- Validate numeric digits only.
		local
			l_regex: RX_PCRE_REGULAR_EXPRESSION
		do
			if str_value /= Void and then not str_value.is_empty then
				create l_regex.make
				l_regex.compile ("^[0-9]+$")
				if l_regex.is_compiled then
					l_regex.match (str_value)
					if not l_regex.has_matched then
						create Result.make ("numeric", "Must contain only digits")
						Result.set_actual_value (str_value)
					end
				end
			end
		end

	validate_one_of (str_value: detachable STRING; choices: ARRAY [STRING]): detachable VALIDATION_ERROR
			-- Validate value is one of the given choices.
		local
			found: BOOLEAN
			choices_str: STRING
		do
			if str_value /= Void then
				across choices as c loop
					if c.same_string (str_value) then
						found := True
					end
				end
				if not found then
					create choices_str.make (50)
					across choices as c loop
						if not choices_str.is_empty then
							choices_str.append (", ")
						end
						choices_str.append (c)
					end
					create Result.make ("one_of", "Must be one of: " + choices_str)
					Result.set_constraint (choices)
					Result.set_actual_value (str_value)
				end
			end
		end

feature {NONE} -- Rule Constants

	Rule_required: INTEGER = 1
	Rule_min_length: INTEGER = 2
	Rule_max_length: INTEGER = 3
	Rule_min_value: INTEGER = 4
	Rule_max_value: INTEGER = 5
	Rule_pattern: INTEGER = 6
	Rule_email: INTEGER = 7
	Rule_url: INTEGER = 8
	Rule_uuid: INTEGER = 9
	Rule_alphanumeric: INTEGER = 10
	Rule_numeric: INTEGER = 11
	Rule_one_of: INTEGER = 12

feature {NONE} -- Pattern Constants

	Email_pattern: STRING = "^[a-zA-Z0-9._%%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
			-- Basic email pattern.

	Url_pattern: STRING = "^https?://[a-zA-Z0-9.-]+(/.*)?$"
			-- Basic URL pattern.

	Uuid_pattern: STRING = "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
			-- UUID pattern.

invariant
	rules_not_void: rules /= Void
	field_name_not_void: field_name /= Void
	custom_message_not_void: custom_message /= Void

end
