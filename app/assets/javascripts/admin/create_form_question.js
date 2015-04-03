window.onload = function() {
	$('#form_question_checkbox').hide();
	$('#checkbox_label').hide();
	$('#form_question_radio_button').hide();
	$('#radiobutton_label').hide();
	$('#count_label').hide();
	$('#answer_count').hide();
}

function selectedOption() {
	if ($("#form_question_question_type_checkbox").is(":checked") || $("#form_question_question_type_radio_button").is(":checked")) {
		$('#count_label').show();
		$('#answer_count').show();
	}
	else {
		$('#count_label').hide();
		$('#answer_count').hide();
	}
}