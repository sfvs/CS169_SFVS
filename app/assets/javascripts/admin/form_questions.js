var ready, set_position;

set_positions = function() {
	// loop through and give each form question a question_pos
	// attribute that holds its position in the DOM
	$('.form_q').each(function(i){
		$(this).attr("data-pos", i+1);
	});
}

ready = function(){
	// call set_positions function
	set_positions();

	$('.sortable').sortable();

	// after order changes
	$('.sortable').sortable().bind('sortupdate', function(e, ui){
		// array to store new order
		updated_order = []

		// set the updated positions
		set_positions();

		// populate the update_order array with the new task positions
		$('.form_q').each(function(i){
			updated_order.push({id: $(this).data("id"), position: i+1});
		});

		// send the updated order via ajax
		$.ajax({
			type: "PUT",
			url: '/admin/forms/1/form_questions/sort', // Need to fix the routing
			data: {order: updated_order} 
		});
	});
}

$(document).ready(ready);