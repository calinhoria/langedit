(function($) {
	$.entwine('ss', function($) {
		// $(document).ajaxError(function(event, jqxhr, settings, thrownError) {
		// alert(thrownError);
		// });
		$("#file_select option").hide();
		$("#file_select option." + $("#locale_select").val()).show();

		$("#locale_select").change(function() {
			$("#file_select option").hide();
			$("#file_select option." + $("#locale_select").val()).show();
		});

		var selected = $("." + $("#locale_select").val() + "." + $("#file_select option:selected").text()).attr("url");
		var locale = $("#locale_select option:selected").text();

		$('#file_select,#locale_select').entwine({
			// Function: onchange
			onchange : function() {
				selected = $("." + $("#locale_select").val() + "." + $("#file_select option:selected").text()).attr("url");
				locale = $("#locale_select option:selected").text();
				$.ajax({
					type : "POST",
					url : "/admin/editlang/",
					data : {
						loadfiles : selected,
					}
				}).done(function(msg) {
					// alert(msg);
					$("#current_locale").html(locale);
					$("#lang_fields").html($(msg).find('#lang_fields').html());
				});
			}
		});

		$("#collect").entwine({
			onclick : function(e) {
				$(this).addClass('loading');
				var button = $(this);
				button.addClass("loading");
				$.ajax({
					type : "POST",
					url : "/admin/editlang/",
					data : {
						collect : true,
					}
				}).done(function(msg) {
					button.removeClass("loading");
					$(".message").html("The translations were successfully collected.");
					$(".message").fadeIn().delay(3000).fadeOut();
					window.location = window.location;

				});
			}
		});

		$("#save").entwine({
			onclick : function(e) {
				var button = $(this);
				button.addClass("loading");
				$.ajax({
					type : "POST",
					url : "/admin/editlang/",
					data : $("#lang_fields").serialize()
				}).done(function(msg) {
					button.removeClass("loading");
					$(".message").html("The translation was successfully saved.");
					$(".message").fadeIn().delay(3000).fadeOut();

				});
			}
		});

	});
})(jQuery);

