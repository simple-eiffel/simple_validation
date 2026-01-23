note
	description: "[
		Result of a validation operation containing success status and any errors.

		X03 Contract Assault: Model-based specifications using simple_mml.
		- model_errors: MML_SET of error codes (unordered)
		- Validity semantics: is_valid = errors.is_empty
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	VALIDATION_RESULT

create
	make_valid,
	make_invalid

feature {NONE} -- Initialization

	make_valid
			-- Create a valid result.
		do
			is_valid := True
			create errors.make (0)
		ensure
			is_valid: is_valid
			no_errors: errors.is_empty
		end

	make_invalid (a_error: VALIDATION_ERROR)
			-- Create an invalid result with `a_error`.
		do
			is_valid := False
			create errors.make (1)
			errors.extend (a_error)
		ensure
			not_valid: not is_valid
			has_error: errors.count = 1
			error_recorded: errors.has (a_error)
			model_has_error: model_error_codes.has (a_error.code)
		end

feature -- Status

	is_valid: BOOLEAN
			-- Did validation pass?

	has_errors: BOOLEAN
			-- Are there any validation errors?
		do
			Result := not errors.is_empty
		ensure
			definition: Result = not errors.is_empty
			model_definition: Result = not model_error_codes.is_empty
		end

feature -- Model Queries

	model_error_codes: MML_SET [STRING]
			-- Mathematical model of error codes as unordered set.
			-- Set semantics: each error code appears once regardless of count.
		local
			l_result: MML_SET [STRING]
		do
			create l_result.default_create
			across errors as ic loop
				l_result := l_result & ic.code
			end
			Result := l_result
		ensure
			codes_from_errors: across errors as ic all Result.has (ic.code) end
		end

	model_error_count: INTEGER
			-- Number of errors in the model.
		do
			Result := errors.count
		ensure
			definition: Result = errors.count
		end

feature -- Access

	errors: ARRAYED_LIST [VALIDATION_ERROR]
			-- List of all validation errors.

	first_error: detachable VALIDATION_ERROR
			-- First error, if any.
		do
			if not errors.is_empty then
				Result := errors.first
			end
		ensure
			result_if_errors: has_errors implies Result /= Void
			no_result_if_valid: is_valid implies Result = Void
		end

	error_messages: ARRAYED_LIST [STRING]
			-- List of all error messages.
		do
			create Result.make (errors.count)
			across errors as ic_err loop
				Result.extend (ic_err.full_message)
			end
		ensure
			same_count: Result.count = errors.count
		end

	error_count: INTEGER
			-- Number of errors.
		do
			Result := errors.count
		ensure
			non_negative: Result >= 0
			definition: Result = errors.count
		end

feature -- Modification

	add_error (a_error: VALIDATION_ERROR)
			-- Add `a_error` to the errors list.
		do
			errors.extend (a_error)
			is_valid := False
		ensure
			error_added: errors.has (a_error)
			error_at_end: errors.last = a_error
			not_valid: not is_valid
			count_increased: errors.count = old errors.count + 1
			model_has_code: model_error_codes.has (a_error.code)
			model_count_increased: model_error_count = old model_error_count + 1
		end

	merge (other: VALIDATION_RESULT)
			-- Merge errors from `other` into Current.
		do
			across other.errors as ic_err loop
				add_error (ic_err)
			end
		ensure
			errors_added: errors.count = old errors.count + other.errors.count
			invalid_if_other_invalid: (old is_valid and not other.is_valid) implies not is_valid
			model_merged: across other.errors as ic all model_error_codes.has (ic.code) end
		end

feature -- Conversion

	to_string: STRING
			-- String representation of result.
		do
			if is_valid then
				Result := "Valid"
			else
				create Result.make (100)
				Result.append ("Invalid: ")
				across error_messages as ic_msg loop
					if not Result.ends_with (": ") then
						Result.append ("; ")
					end
					Result.append (ic_msg)
				end
			end
		end

invariant
	errors_exist: attached errors
	valid_implies_no_errors: is_valid implies errors.is_empty
	errors_implies_invalid: not errors.is_empty implies not is_valid
	model_consistent: model_error_count = errors.count
	validity_definition: is_valid = errors.is_empty

end
