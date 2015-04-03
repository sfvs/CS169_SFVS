window.onload = function() {
	document.getElementById('form_question_checkbox').style.display = 'none';
	document.getElementById('checkbox_label').style.display = 'none';
	document.getElementById('form_question_radio_button').style.display = 'none';
	document.getElementById('radiobutton_label').style.display = 'none';
}

function selectedOption() {
	if (document.getElementById('form_question_question_type_checkbox').checked) {
		document.getElementById('form_question_checkbox').style.display = 'block';
		document.getElementById('checkbox_label').style.display = 'block';
		document.getElementById('form_question_radio_button').style.display = 'none';
		document.getElementById('radiobutton_label').style.display = 'none';
	}
	else if (document.getElementById('form_question_question_type_radio_button').checked) {
		document.getElementById('form_question_checkbox').style.display = 'none';
		document.getElementById('checkbox_label').style.display = 'none';
		document.getElementById('form_question_radio_button').style.display = 'block';
		document.getElementById('radiobutton_label').style.display = 'block';
	}
	else {
		document.getElementById('form_question_checkbox').style.display = 'none';
		document.getElementById('checkbox_label').style.display = 'none';
		document.getElementById('form_question_radio_button').style.display = 'none';
		document.getElementById('radiobutton_label').style.display = 'none';
	}
}