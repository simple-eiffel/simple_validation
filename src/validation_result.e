note
	description: "Result of a validation operation containing success status and any errors"
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
		require
			error_not_void: a_error /= Void
		do
			is_valid := False
			create errors.make (1)
			errors.extend (a_error)
		ensure
			not_valid: not is_valid
			has_error: errors.count = 1
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
			across errors as err loop
				Result.extend (err.full_message)
			end
		ensure
			result_not_void: Result /= Void
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
		require
			error_not_void: a_error /= Void
		do
			errors.extend (a_error)
			is_valid := False
		ensure
			error_added: errors.has (a_error)
			not_valid: not is_valid
			count_increased: errors.count = old errors.count + 1
		end

	merge (other: VALIDATION_RESULT)
			-- Merge errors from `other` into Current.
		require
			other_not_void: other /= Void
		do
			across other.errors as err loop
				add_error (err)
			end
		ensure
			errors_added: errors.count >= old errors.count
			invalid_if_other_invalid: (old is_valid and not other.is_valid) implies not is_valid
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
				across error_messages as msg loop
					if not Result.ends_with (": ") then
						Result.append ("; ")
					end
					Result.append (msg)
				end
			end
		ensure
			result_not_void: Result /= Void
		end

invariant
	errors_not_void: errors /= Void
	valid_implies_no_errors: is_valid implies errors.is_empty
	errors_implies_invalid: not errors.is_empty implies not is_valid

end
