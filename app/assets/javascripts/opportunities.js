$(function() {
	refresh_funnel();
});

$(document).on('page:load', function() {
	refresh_funnel();
});

function refresh_funnel() {
    url = "/opportunities/funnel_data.json"
    $.getJSON(url, function(data) {
	    var placeholder = $("#placeholder");
		$.plot('#placeholder', data, {
		    series: {
		        funnel: {
		            show: true,
					stem: {
						height: 0.2,
						width: 0.4
					},
					margin: {
	                    //right: 0.35
					},
		            label: {
						show: true,
						align: "center",
						threshold: 0.05,
						formatter: labelFormatter
	                },
					highlight: {
						opacity: 0.2
					}
				},
		    },
			grid: {
				hoverable: true,
				clickable: true
			}
		});

		placeholder.bind("plotclick", function(event, pos, obj) {

			if (!obj) {
				return;
			}

			//alert(obj.series.label + ": " + obj.series.value);
		    
		    $.ajax({url: "/opportunities.js?stage=" + obj.series.label, type: "GET", success: function(resp){}});

		});

    });

};

function labelFormatter(label, series) {
	return "<div style='font-size:11pt; text-align:center; padding:2px; color:#fff;'>"+series.value+"</div>";
};
