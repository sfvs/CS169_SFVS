window.onload = function() {
	$('.checkbox_fields').hide();
	$('.radio_button_fields').hide();
	// $('#answer_count').hide();
	// $('#ok_but').hide();
}

// function show_button() {
// 	$('#count_label').show();
// 	$('#answer_count').show();
// 	$('#ok_but').show();
// }

// function hide_button() {
// 	$('#count_label').hide();
// 	$('#answer_count').hide();
// 	$('#ok_but').hide();
// }

function selectedOption() {
	if ($("#form_question_question_type_checkbox").is(":checked")) {
		$('.checkbox_fields').show();
		$('.radio_button_fields').hide();
		// show_button();
		// var s = $('#answer_count').val();
		// for (i = 0; i < s; i++) {
		// 	$('#radiobutton_label').remove();
		// 	$('#form_question_radio_button').remove();
		// }
	}
	else if ( $("#form_question_question_type_radio_button").is(":checked")) {
		$('.checkbox_fields').hide();
		$('.radio_button_fields').show();
		// show_button();
		// var s = $('#answer_count').val();
		// for (i = 0; i < s; i++) {
		// 	$('#checkbox_label').remove();
		// 	$('#form_question_checkbox').remove();
		// }
	}
	else {
		// hide_button();
		$('.checkbox_fields').hide();
		$('.radio_button_fields').hide();
	}
}

// function createFields() {
// 	hide_button();
// 	var option = $("input[type='radio'][name='form_question[question_type]']:checked").val();
// 	var count = $('#answer_count').val();
// 	for (i = 0; i < count; i++) {
// 		if (option == "checkbox") {
// 			$('.input_fields').append("<label for=\"form_question_answer\" id=\"checkbox_label\">Checkbox Answer</label>")
// 			$('.input_fields').append("<input id=\"form_question_checkbox\" name=\"q_answer[answers[" + i.toString() + "]]\" size=\"20\" type=\"text\"/>");
// 		}
// 		else if (option == "radio_button") {
// 			$('.input_fields').append("<label for=\"form_question_answer\" id=\"radiobutton_label\">Radio Button Answer</label>")
// 			$('.input_fields').append("<input id=\"form_question_radio_button\" name=\"q_answer[answers[" + i.toString() + "]]\" size=\"20\" type=\"text\"/>");
// 		}
// 	}
// }