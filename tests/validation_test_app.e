note
	description: "Test application for simple_validation"
	author: "Larry Rix"

class
	VALIDATION_TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests.
		local
			tests: VALIDATION_TEST_SET
		do
			create tests
			io.put_string ("simple_validation test runner%N")
			io.put_string ("=================================%N%N")

			passed := 0
			failed := 0

			-- VALIDATION_ERROR tests
			io.put_string ("VALIDATION_ERROR Tests%N")
			io.put_string ("----------------------%N")
			run_test (agent tests.test_make_creates_error_with_code_and_message, "test_make_creates_error_with_code_and_message")
			run_test (agent tests.test_set_field_name, "test_set_field_name")
			run_test (agent tests.test_set_constraint, "test_set_constraint")
			run_test (agent tests.test_set_actual_value, "test_set_actual_value")
			run_test (agent tests.test_full_message_without_field_name, "test_full_message_without_field_name")
			run_test (agent tests.test_full_message_with_field_name, "test_full_message_with_field_name")

			-- VALIDATION_RESULT tests
			io.put_string ("%NVALIDATION_RESULT Tests%N")
			io.put_string ("------------------------%N")
			run_test (agent tests.test_make_valid_creates_valid_result, "test_make_valid_creates_valid_result")
			run_test (agent tests.test_make_invalid_creates_invalid_result, "test_make_invalid_creates_invalid_result")
			run_test (agent tests.test_has_errors_reflects_error_list, "test_has_errors_reflects_error_list")
			run_test (agent tests.test_first_error_when_empty, "test_first_error_when_empty")
			run_test (agent tests.test_first_error_when_has_errors, "test_first_error_when_has_errors")
			run_test (agent tests.test_error_messages_returns_all_messages, "test_error_messages_returns_all_messages")
			run_test (agent tests.test_error_count, "test_error_count")
			run_test (agent tests.test_add_error_adds_error_and_invalidates, "test_add_error_adds_error_and_invalidates")
			run_test (agent tests.test_merge_adds_errors_from_other, "test_merge_adds_errors_from_other")
			run_test (agent tests.test_merge_valid_into_valid_stays_valid, "test_merge_valid_into_valid_stays_valid")
			run_test (agent tests.test_to_string_when_valid, "test_to_string_when_valid")
			run_test (agent tests.test_to_string_when_invalid_one_error, "test_to_string_when_invalid_one_error")

			-- SIMPLE_VALIDATOR tests: Basic
			io.put_string ("%NSIMPLE_VALIDATOR Tests - Basic%N")
			io.put_string ("-------------------------------%N")
			run_test (agent tests.test_empty_validator_passes_any_value, "test_empty_validator_passes_any_value")

			-- SIMPLE_VALIDATOR tests: Required
			io.put_string ("%NSIMPLE_VALIDATOR Tests - Required%N")
			io.put_string ("-----------------------------------%N")
			run_test (agent tests.test_required_passes_non_empty_string, "test_required_passes_non_empty_string")
			run_test (agent tests.test_required_fails_empty_string, "test_required_fails_empty_string")
			run_test (agent tests.test_required_fails_void, "test_required_fails_void")

			-- SIMPLE_VALIDATOR tests: Length
			io.put_string ("%NSIMPLE_VALIDATOR Tests - Length%N")
			io.put_string ("---------------------------------%N")
			run_test (agent tests.test_min_length_passes_when_long_enough, "test_min_length_passes_when_long_enough")
			run_test (agent tests.test_min_length_fails_when_too_short, "test_min_length_fails_when_too_short")
			run_test (agent tests.test_max_length_passes_when_short_enough, "test_max_length_passes_when_short_enough")
			run_test (agent tests.test_max_length_fails_when_too_long, "test_max_length_fails_when_too_long")
			run_test (agent tests.test_length_between_passes_in_range, "test_length_between_passes_in_range")

			-- SIMPLE_VALIDATOR tests: Value
			io.put_string ("%NSIMPLE_VALIDATOR Tests - Value%N")
			io.put_string ("--------------------------------%N")
			run_test (agent tests.test_min_value_passes_when_greater_or_equal, "test_min_value_passes_when_greater_or_equal")
			run_test (agent tests.test_min_value_fails_when_below, "test_min_value_fails_when_below")
			run_test (agent tests.test_max_value_passes_when_less_or_equal, "test_max_value_passes_when_less_or_equal")
			run_test (agent tests.test_max_value_fails_when_above, "test_max_value_fails_when_above")

			-- SIMPLE_VALIDATOR tests: Formats
			io.put_string ("%NSIMPLE_VALIDATOR Tests - Formats%N")
			io.put_string ("----------------------------------%N")
			run_test (agent tests.test_email_passes_valid_addresses, "test_email_passes_valid_addresses")
			run_test (agent tests.test_email_fails_invalid_addresses, "test_email_fails_invalid_addresses")
			run_test (agent tests.test_url_passes_valid_urls, "test_url_passes_valid_urls")
			run_test (agent tests.test_url_fails_invalid_urls, "test_url_fails_invalid_urls")
			run_test (agent tests.test_uuid_passes_valid_uuids, "test_uuid_passes_valid_uuids")
			run_test (agent tests.test_uuid_fails_invalid_uuids, "test_uuid_fails_invalid_uuids")

			-- SIMPLE_VALIDATOR tests: Pattern
			io.put_string ("%NSIMPLE_VALIDATOR Tests - Pattern%N")
			io.put_string ("----------------------------------%N")
			run_test (agent tests.test_alphanumeric_passes_letters_and_digits, "test_alphanumeric_passes_letters_and_digits")
			run_test (agent tests.test_alphanumeric_fails_special_chars, "test_alphanumeric_fails_special_chars")
			run_test (agent tests.test_numeric_passes_digits_only, "test_numeric_passes_digits_only")
			run_test (agent tests.test_numeric_fails_non_digits, "test_numeric_fails_non_digits")
			run_test (agent tests.test_pattern_passes_matching_string, "test_pattern_passes_matching_string")
			run_test (agent tests.test_pattern_fails_non_matching_string, "test_pattern_fails_non_matching_string")

			-- SIMPLE_VALIDATOR tests: One Of
			io.put_string ("%NSIMPLE_VALIDATOR Tests - One Of%N")
			io.put_string ("---------------------------------%N")
			run_test (agent tests.test_one_of_passes_valid_choice, "test_one_of_passes_valid_choice")
			run_test (agent tests.test_one_of_fails_invalid_choice, "test_one_of_fails_invalid_choice")

			-- SIMPLE_VALIDATOR tests: Chaining
			io.put_string ("%NSIMPLE_VALIDATOR Tests - Chaining%N")
			io.put_string ("-----------------------------------%N")
			run_test (agent tests.test_chained_validators_all_apply, "test_chained_validators_all_apply")
			run_test (agent tests.test_chained_validators_pass_valid_input, "test_chained_validators_pass_valid_input")

			-- SIMPLE_VALIDATOR tests: Custom
			io.put_string ("%NSIMPLE_VALIDATOR Tests - Custom%N")
			io.put_string ("---------------------------------%N")
			run_test (agent tests.test_with_message_uses_custom_message, "test_with_message_uses_custom_message")
			run_test (agent tests.test_with_field_name_appears_in_error, "test_with_field_name_appears_in_error")

			io.put_string ("%N=================================%N")
			io.put_string ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				io.put_string ("TESTS FAILED%N")
			else
				io.put_string ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Implementation

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				io.put_string ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			io.put_string ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
