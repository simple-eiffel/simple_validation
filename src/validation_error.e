note
	description: "Represents a single validation error with actionable details"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	VALIDATION_ERROR

create
	make

feature {NONE} -- Initialization

	make (a_code: STRING; a_message: STRING)
			-- Create error with `a_code` and `a_message`.
		require
			code_not_void: a_code /= Void
			code_not_empty: not a_code.is_empty
			message_not_void: a_message /= Void
			message_not_empty: not a_message.is_empty
		do
			code := a_code
			message := a_message
			create field_name.make_empty
		ensure
			code_set: code.same_string (a_code)
			message_set: message.same_string (a_message)
		end

feature -- Access

	code: STRING
			-- Error code (e.g., "required", "min_length", "pattern").

	message: STRING
			-- Human-readable error message.

	field_name: STRING
			-- Name of the field that failed validation.

	constraint: detachable ANY
			-- The constraint that was violated (e.g., minimum length value).

	actual_value: detachable ANY
			-- The actual value that was provided.

feature -- Modification

	set_field_name (a_name: STRING)
			-- Set field name to `a_name`.
		require
			name_not_void: a_name /= Void
		do
			field_name := a_name
		ensure
			field_name_set: field_name.same_string (a_name)
		end

	set_constraint (a_constraint: ANY)
			-- Set constraint value.
		require
			constraint_not_void: a_constraint /= Void
		do
			constraint := a_constraint
		ensure
			constraint_set: constraint = a_constraint
		end

	set_actual_value (a_value: detachable ANY)
			-- Set actual value.
		do
			actual_value := a_value
		ensure
			actual_value_set: actual_value = a_value
		end

feature -- Output

	full_message: STRING
			-- Complete error message with field name if available.
		do
			if field_name.is_empty then
				Result := message
			else
				Result := field_name + ": " + message
			end
		ensure
			result_not_empty: not Result.is_empty
		end

invariant
	code_not_void: code /= Void
	code_not_empty: not code.is_empty
	message_not_void: message /= Void
	message_not_empty: not message.is_empty
	field_name_not_void: field_name /= Void

end
