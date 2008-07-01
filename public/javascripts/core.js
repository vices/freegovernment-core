var Feedback = {
	init: function() {
		$('#feedback_link').css('display', 'block').click(this.clickIt);
		$('#feedback_form .close').click(function() {
			Feedback.closeForm();
		});
		$('#feedback_form').ajaxForm(function() {
			$('#feedback_form .submit').text('Thanks!');
			setTimeout(Feedback.finishSending, 1000);
		});
	},
	clickIt: function() {
		if ($('#feedback_form').css('display') == 'none') {
			$('#feedback_form').css('display', 'block');
		} else {
			Feedback.closeForm();
		}
	},
	closeForm: function() {
		$('#feedback_form').css('display', 'none');
	},
	finishSending: function() {
		Feedback.closeForm();
		setTimeout(function() {
			$('#feedback_form .submit').text('Send Feedback!');
			$('#feedback_form textarea').val('');
		}, 500);
	}
}

$(document).ready(function(){
	Feedback.init();
});