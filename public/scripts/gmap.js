window.onload = function() 
{
	var markers = new Object();
	var map = new google.maps.Map(document.getElementById("map_aera"), {
		center: new google.maps.LatLng(44.837978, -0.557384),
		zoom: 2,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	
	$(document).ready(function(){
		$( "input[type=submit], button" ).button();
		
		$("#collection_content").on("click", ".display_map", function() {
			
			var queryloc = '{"' + $(this).attr('entry') + '": {"$exists": 1}}';
			$('#shell_query').val(queryloc);
			$('#shell_projection').val('');
			$.ajax({
				type: "POST",
				url: "/ajax/execute",
				data: { query: queryloc, projection: '' }
			}).done(function(data) {
				var markers = eval(data);
				console.log(markers);
				/*markers[] = new google.maps.Marker({
					position: new google.maps.LatLng(tmp_alert.lat, tmp_alert.lng),
					map: map,
					icon:image,
					title:''
				});*/
				
				
				
				$('#map_aera').show();
				google.maps.event.trigger(map, 'resize');
			});
		});
	});

}