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
				console.log(markers_data);
				$.each(markers_data,function(k1, v1 )
				{
					markers[k1] = new google.maps.Marker({
						position: new google.maps.LatLng(v1['loc']['lat'], v1['loc']['long']),
						map: map,
						icon:'/ressources/marker.png',
						title:v1['_id']['$oid']
					});
				});

				$('#map_aera').show();
				google.maps.event.trigger(map, 'resize');
			});
		});
		
		google.maps.event.addListener(map, 'click', function(event) {
			var tempArray = new Array();
			//var test = google.maps.geometry.spherical.computeDistanceBetween(markers[0].getPosition(), new google.maps.LatLng(event.latLng.lat(),event.latLng.lng() ));
			//console.log(markers_data);
			$.each(markers_data,function(k1, v1 )
			{
				var temp_dist = google.maps.geometry.spherical.computeDistanceBetween(new google.maps.LatLng(v1['loc']['lat'], v1['loc']['long']), new google.maps.LatLng(event.latLng.lat(),event.latLng.lng() ));
				tempArray.push([[v1['_id']['$oid']], parseInt(temp_dist.toFixed(0))]);
			});
			tempArray = (tempArray.sort(function(a, b) {return a[1] - b[1]})).slice(0,5);
			console.log(tempArray);
			// Syntaxe select where in : {"yahoo.woetype" : { "$in" : [11, 7]}} pour l'id : {"_id" : { "$in" : ["4f520122ecf6171327000137", "4f4f49c09d1bd90728000034"]}} -----> ne fonctionne pas
			
		});
		
	});

}