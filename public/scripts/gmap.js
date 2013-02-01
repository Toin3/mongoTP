window.onload = function() 
{
	var markers_data = new Object();
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
				markers_data = eval(data);
				build_marker(markers_data);
				$('#map_aera').show();
				google.maps.event.trigger(map, 'resize');
			});
		});
		
		google.maps.event.addListener(map, 'click', function(event) {
			$.ajax({
				type: "POST",
				url: "/ajax/gmap",
				data: { latitude: event.latLng.lat(), longitude: event.latLng.lng() }
			}).done(function(data) {
				console.log(eval(data));
				build_marker(eval(data));
			});
		});
		
		
		function build_marker(data){			
			$.each(markers,function(k, v )
			{
				 markers[k].setMap(null);
			});
			markers = new Object();
			
			$.each(data,function(k1, v1 )
			{
				markers[k1] = new google.maps.Marker({
					position: new google.maps.LatLng(v1['loc']['lat'], v1['loc']['long']),
					map: map,
					icon:'/ressources/marker.png',
					title:v1['_id']['$oid']
				});
			});
		}
		
	});

}