note
	description: "Test set for simple_validation library"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	testing: "covers"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- VALIDATION_ERROR Tests

	test_make_creates_error_with_code_and_message
			-- Test basic error creation.
		note
			testing: "covers/{VALIDATION_ERROR}.make"
		local
			err: VALIDATION_ERROR
		do
			create err.make ("required", "This field is required")
			assert_strings_equal ("code set", "required", err.code)
			assert_strings_equal ("message set", "This field is required", err.message)
			assert_true ("field_name empty", err.field_name.is_empty)
			assert ("constraint void", err.constraint = Void)
			assert ("actual_value void", err.actual_value = Void)
		end

	test_set_field_name
			-- Test setting field name.
		note
			testing: "covers/{VALIDATION_ERROR}.set_field_name"
		local
			err: VALIDATION_ERROR
		do
			create err.make ("required", "Required")
			err.set_field_name ("email")
			assert_strings_equal ("field_name set", "email", err.field_name)
		end

	test_set_constraint
			-- Test setting constraint value.
		note
			testing: "covers/{VALIDATION_ERROR}.set_constraint"
		local
			err: VALIDATION_ERROR
		do
			create err.make ("min_length", "Too short")
			err.set_constraint (8)
			if attached {INTEGER_REF} err.constraint as c then
				assert_integers_equal ("constraint is 8", 8, c.item)
			else
				assert ("constraint is integer", False)
			end
		end

	test_set_actual_value
			-- Test setting actual value.
		note
			testing: "covers/{VALIDATION_ERROR}.set_actual_value"
		local
			err: VALIDATION_ERROR
		do
			create err.make ("min_length", "Too short")
			err.set_actual_value ("abc")
			if attached {STRING} err.actual_value as v then
				assert_strings_equal ("actual_value set", "abc", v)
			else
				assert ("actual_value is string", False)
			end
		end

	test_full_message_without_field_name
			-- Test full_message when field_name is empty.
		note
			testing: "covers/{VALIDATION_ERROR}.full_message"
		local
			err: VALIDATION_ERROR
		do
			create err.make ("required", "This field is required")
			assert_strings_equal ("full_message is message", "This field is required", err.full_message)
		end

	test_full_message_with_field_name
			-- Test full_message includes field name.
		note
			testing: "covers/{VALIDATION_ERROR}.full_message"
		local
			err: VALIDATION_ERROR
		do
			create err.make ("required", "This field is required")
			err.set_field_name ("username")
			assert_strings_equal ("full_message with field", "username: This field is required", err.full_message)
		end

feature -- VALIDATION_RESULT Tests

	test_make_valid_creates_valid_result
			-- Test make_valid creates a valid result.
		note
			testing: "covers/{VALIDATION_RESULT}.make_valid"
		local
			res: VALIDATION_RESULT
		do
			create res.make_valid
			assert_true ("is_valid", res.is_valid)
			assert_true ("no errors", res.errors.is_empty)
			assert_false ("has_errors false", res.has_errors)
		end

	test_make_invalid_creates_invalid_result
			-- Test make_invalid creates invalid result with error.
		note
			testing: "covers/{VALIDATION_RESULT}.make_invalid"
		local
			res: VALIDATION_RESULT
			err: VALIDATION_ERROR
		do
			create err.make ("required", "Required")
			create res.make_invalid (err)
			assert_false ("not valid", res.is_valid)
			assert_true ("has_errors", res.has_errors)
			assert_integers_equal ("one error", 1, res.errors.count)
		end

	test_has_errors_reflects_error_list
			-- Test has_errors matches error list state.
		note
			testing: "covers/{VALIDATION_RESULT}.has_errors"
		local
			res: VALIDATION_RESULT
			err: VALIDATION_ERROR
		do
			create res.make_valid
			assert_false ("initially no errors", res.has_errors)
			create err.make ("required", "Required")
			res.add_error (err)
			assert_true ("now has errors", res.has_errors)
		end

	test_first_error_when_empty
			-- Test first_error returns Void when no errors.
		note
			testing: "covers/{VALIDATION_RESULT}.first_error"
		local
			res: VALIDATION_RESULT
		do
			create res.make_valid
			assert ("first_error void", res.first_error = Void)
		end

	test_first_error_when_has_errors
			-- Test first_error returns first error.
		note
			testing: "covers/{VALIDATION_RESULT}.first_error"
		local
			res: VALIDATION_RESULT
			err1, err2: VALIDATION_ERROR
		do
			create res.make_valid
			create err1.make ("first", "First error")
			create err2.make ("second", "Second error")
			res.add_error (err1)
			res.add_error (err2)
			if attached res.first_error as fe then
				assert_strings_equal ("first error returned", "first", fe.code)
			else
				assert ("first_error not void", False)
			end
		end

	test_error_messages_returns_all_messages
			-- Test error_messages returns list of all messages.
		note
			testing: "covers/{VALIDATION_RESULT}.error_messages"
		local
			res: VALIDATION_RESULT
			err1, err2: VALIDATION_ERROR
			msgs: ARRAYED_LIST [STRING]
		do
			create res.make_valid
			create err1.make ("e1", "Error one")
			create err2.make ("e2", "Error two")
			err2.set_field_name ("field")
			res.add_error (err1)
			res.add_error (err2)
			msgs := res.error_messages
			assert_integers_equal ("two messages", 2, msgs.count)
			assert_strings_equal ("first message", "Error one", msgs [1])
			assert_strings_equal ("second message with field", "field: Error two", msgs [2])
		end

	test_error_count
			-- Test error_count returns correct count.
		note
			testing: "covers/{VALIDATION_RESULT}.error_count"
		local
			res: VALIDATION_RESULT
			err: VALIDATION_ERROR
		do
			create res.make_valid
			assert_integers_equal ("initially zero", 0, res.error_count)
			create err.make ("e1", "Error")
			res.add_error (err)
			assert_integers_equal ("now one", 1, res.error_count)
		end

	test_add_error_adds_error_and_invalidates
			-- Test add_error adds error and sets is_valid to False.
		note
			testing: "covers/{VALIDATION_RESULT}.add_error"
		local
			res: VALIDATION_RESULT
			err: VALIDATION_ERROR
		do
			create res.make_valid
			assert_true ("initially valid", res.is_valid)
			create err.make ("test", "Test error")
			res.add_error (err)
			assert_false ("no longer valid", res.is_valid)
			assert_true ("error added", res.errors.has (err))
		end

	test_merge_adds_errors_from_other
			-- Test merge combines errors from another result.
		note
			testing: "covers/{VALIDATION_RESULT}.merge"
		local
			res1, res2: VALIDATION_RESULT
			err1, err2: VALIDATION_ERROR
		do
			create res1.make_valid
			create err1.make ("e1", "Error 1")
			res1.add_error (err1)
			create res2.make_valid
			create err2.make ("e2", "Error 2")
			res2.add_error (err2)
			res1.merge (res2)
			assert_integers_equal ("merged count", 2, res1.error_count)
			assert_false ("not valid", res1.is_valid)
		end

	test_merge_valid_into_valid_stays_valid
			-- Test merging two valid results stays valid.
		note
			testing: "covers/{VALIDATION_RESULT}.merge"
		local
			res1, res2: VALIDATION_RESULT
		do
			create res1.make_valid
			create res2.make_valid
			res1.merge (res2)
			assert_true ("still valid", res1.is_valid)
			assert_integers_equal ("no errors", 0, res1.error_count)
		end

	test_to_string_when_valid
			-- Test to_string for valid result.
		note
			testing: "covers/{VALIDATION_RESULT}.to_string"
		local
			res: VALIDATION_RESULT
		do
			create res.make_valid
			assert_strings_equal ("valid string", "Valid", res.to_string)
		end

	test_to_string_when_invalid_one_error
			-- Test to_string with one error.
		note
			testing: "covers/{VALIDATION_RESULT}.to_string"
		local
			res: VALIDATION_RESULT
			err: VALIDATION_ERROR
		do
			create err.make ("required", "Field is required")
			create res.make_invalid (err)
			assert_strings_equal ("invalid string", "Invalid: Field is required", res.to_string)
		end

feature -- SIMPLE_VALIDATOR Tests: Basic

	test_empty_validator_passes_any_value
			-- Test validator with no rules passes anything.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.is_valid"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("passes string", v.is_valid ("hello"))
			assert_true ("passes integer", v.is_valid (42))
			assert_true ("passes void", v.is_valid (Void))
		end

feature -- SIMPLE_VALIDATOR Tests: Required

	test_required_passes_non_empty_string
			-- Test required passes non-empty string.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.required"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("passes", v.required.is_valid ("hello"))
		end

	test_required_fails_empty_string
			-- Test required fails on empty string.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.required"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.required.validate ("")
			assert_false ("fails", res.is_valid)
			if attached res.first_error as err then
				assert_strings_equal ("code", "required", err.code)
			end
		end

	test_required_fails_void
			-- Test required fails on Void.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.required"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_false ("fails", v.required.is_valid (Void))
		end

feature -- SIMPLE_VALIDATOR Tests: Length

	test_min_length_passes_when_long_enough
			-- Test min_length passes when string meets minimum.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.min_length"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("passes at exactly min", v.min_length (5).is_valid ("hello"))
		end

	test_min_length_fails_when_too_short
			-- Test min_length fails when string too short.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.min_length"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.min_length (5).validate ("hi")
			assert_false ("fails", res.is_valid)
			if attached res.first_error as err then
				assert_strings_equal ("code", "min_length", err.code)
			end
		end

	test_max_length_passes_when_short_enough
			-- Test max_length passes when string within limit.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.max_length"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("passes at exactly max", v.max_length (5).is_valid ("hello"))
		end

	test_max_length_fails_when_too_long
			-- Test max_length fails when string too long.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.max_length"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.max_length (5).validate ("hello world")
			assert_false ("fails", res.is_valid)
		end

	test_length_between_passes_in_range
			-- Test length_between passes when length in range.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.length_between"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("passes at min", v.length_between (3, 10).is_valid ("abc"))
		end

feature -- SIMPLE_VALIDATOR Tests: Value

	test_min_value_passes_when_greater_or_equal
			-- Test min_value passes when value >= minimum.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.min_value"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("passes at min", v.min_value (18).is_valid (18))
		end

	test_min_value_fails_when_below
			-- Test min_value fails when value < minimum.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.min_value"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.min_value (18).validate (16)
			assert_false ("fails", res.is_valid)
		end

	test_max_value_passes_when_less_or_equal
			-- Test max_value passes when value <= maximum.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.max_value"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("passes at max", v.max_value (100).is_valid (100))
		end

	test_max_value_fails_when_above
			-- Test max_value fails when value > maximum.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.max_value"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_false ("fails", v.max_value (100).is_valid (150))
		end

feature -- SIMPLE_VALIDATOR Tests: Format

	test_email_passes_valid_addresses
			-- Test email passes valid email addresses.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.email"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("simple email", v.email.is_valid ("user@example.com"))
		end

	test_email_fails_invalid_addresses
			-- Test email fails invalid addresses.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.email"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.email.validate ("not-an-email")
			assert_false ("no @ fails", res.is_valid)
		end

	test_url_passes_valid_urls
			-- Test url passes valid URLs.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.url"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("https", v.url.is_valid ("https://example.com"))
		end

	test_url_fails_invalid_urls
			-- Test url fails invalid URLs.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.url"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_false ("no protocol fails", v.url.is_valid ("example.com"))
		end

	test_uuid_passes_valid_uuids
			-- Test uuid passes valid UUIDs.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.uuid"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("valid uuid", v.uuid.is_valid ("550e8400-e29b-41d4-a716-446655440000"))
		end

	test_uuid_fails_invalid_uuids
			-- Test uuid fails invalid UUIDs.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.uuid"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_false ("wrong format", v.uuid.is_valid ("not-a-uuid"))
		end

feature -- SIMPLE_VALIDATOR Tests: Pattern

	test_alphanumeric_passes_letters_and_digits
			-- Test alphanumeric passes letters and digits only.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.alphanumeric"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("mixed", v.alphanumeric.is_valid ("Hello123"))
		end

	test_alphanumeric_fails_special_chars
			-- Test alphanumeric fails with special characters.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.alphanumeric"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_false ("space fails", v.alphanumeric.is_valid ("hello world"))
		end

	test_numeric_passes_digits_only
			-- Test numeric passes digits only.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.numeric"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("digits", v.numeric.is_valid ("12345"))
		end

	test_numeric_fails_non_digits
			-- Test numeric fails non-digit characters.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.numeric"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_false ("letters fail", v.numeric.is_valid ("123abc"))
		end

	test_pattern_passes_matching_string
			-- Test pattern passes when regex matches.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.pattern"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("matches", v.pattern ("^[A-Z]{3}[0-9]{3}$").is_valid ("ABC123"))
		end

	test_pattern_fails_non_matching_string
			-- Test pattern fails when regex doesn't match.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.pattern"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.pattern ("^[A-Z]{3}[0-9]{3}$").validate ("abc123")
			assert_false ("fails", res.is_valid)
		end

feature -- SIMPLE_VALIDATOR Tests: One Of

	test_one_of_passes_valid_choice
			-- Test one_of passes when value in choices.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.one_of"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("first choice", v.one_of (<<"red", "green", "blue">>).is_valid ("red"))
		end

	test_one_of_fails_invalid_choice
			-- Test one_of fails when value not in choices.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.one_of"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.one_of (<<"red", "green", "blue">>).validate ("yellow")
			assert_false ("fails", res.is_valid)
		end

feature -- SIMPLE_VALIDATOR Tests: Chaining

	test_chained_validators_all_apply
			-- Test multiple validators are all checked.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.validate"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.required.min_length (3).max_length (10).validate ("hi")
			assert_false ("fails min_length", res.is_valid)
		end

	test_chained_validators_pass_valid_input
			-- Test chained validators pass valid input.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.validate"
		local
			v: SIMPLE_VALIDATOR
		do
			create v.make
			assert_true ("passes all", v.required.min_length (3).max_length (10).alphanumeric.is_valid ("Hello123"))
		end

feature -- SIMPLE_VALIDATOR Tests: Custom

	test_with_message_uses_custom_message
			-- Test custom message overrides default.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.with_message"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.required.with_message ("Please enter your email").validate ("")
			assert_false ("fails", res.is_valid)
			if attached res.first_error as err then
				assert_strings_equal ("custom message", "Please enter your email", err.message)
			end
		end

	test_with_field_name_appears_in_error
			-- Test field name appears in error.
		note
			testing: "covers/{SIMPLE_VALIDATOR}.with_field_name"
		local
			v: SIMPLE_VALIDATOR
			res: VALIDATION_RESULT
		do
			create v.make
			res := v.required.with_field_name ("email").validate ("")
			assert_false ("fails", res.is_valid)
			if attached res.first_error as err then
				assert_strings_equal ("field name set", "email", err.field_name)
			end
		end

end
