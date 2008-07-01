var Feedback = {
	init: function() {
		$('#feedback_link').css('display', 'block').click(this.clickIt);
		$('#feedback_form .close').click(function() {
			$('#feedback_form').css('display', 'none');
		});

	},
	clickIt: function() {
		if ($('#feedback_form').css('display') == 'none') {
			$('#feedback_form').css('display', 'block');
		} else {
			$('#feedback_form').css('display', 'none');
		}
	}
}

$(document).ready(function(){
	Feedback.init();
});