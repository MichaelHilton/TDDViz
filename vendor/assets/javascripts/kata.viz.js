
function drawCompilePoints() {

	//Draw Compile Points
	var bar = chart.selectAll("g")
		.data(data)
		.enter()
		.append("g");

	bar.append("rect")
		.attr("x", function(d, i) {
			return x(d.git_tag);
		})
		.attr("y", -5)
		.attr("width", 10)
		.attr("height", 10)
		.attr("r", 4)
		.attr("rx", 2.5)
		.attr("ry", 2.5)
		.attr("transform", "translate(" + margin.left + "," + lineHeight + ")")
		.attr("fill", function(d) {
			return TDDColor(d.light_color);
		})
		.attr("stroke-width", 2)
		.attr("stroke", function(d) {
			var currColor = TDDColor(d.light_color);
			if(currColor == "white"){
				return "gray";	
			}else{
				return currColor;
			}
		});
		// .attr("style", "outline: thin solid red;");   //This will do the job;

}

function drawCycleArea(){
	chart.selectAll("h")
    .data(gon.allCycles)
    .enter().append("rect")
    .attr("x", function(d, i) {
    	// if(d.valid_tdd){
    		      return x(d.startCompile - 1);
    	// }

    })
    .attr("y", 15)
    .attr("width",
      function(d, i) {
      	// if(d.valid_tdd){
        return x(d.endCompile - d.startCompile + 1);
      // }
      })
    .attr("height", 30)
    .attr("rx", 6)
    .attr("ry", 6)
    .attr("stroke", "grey")
    .attr("fill", function(d) {
      if (d.valid_tdd == true) {
        return "#EEEEEE";
      }
      if (d.valid_tdd == false) {
        // return "#6F6F6F";
      }

    })
    .attr("transform", "translate(" + margin.left + ",-10)")
	.attr("id", function(d, i){ 
		var result = "Cycle_Area" + i; 
		return result; 
	});

}

function diplay_kata_algorithm(phases) {
	phaseBars = chart.selectAll("f")
		.data(phases)
		.enter().append("rect")
		.attr("x", function(d, i) {
			return x(d.compiles[0] - 1);
		})
		.attr("y", 3 )
		.attr("width",
			function(d, i) {
				return x(d.compiles[d.compiles.length - 1] - d.compiles[0] + 1);
			})
		.attr("height", 15)
		.attr("stroke", "grey")
		.attr("fill",
			function(d) {
				return TDDColor(d.color);
			})
		.attr("transform", "translate(" + margin.left + ",10)")
		;
}


function drawAlgorithmMarkup(phases,show_label) {
	console.log("drawAlgorithmMarkup");

	//   //Draw phase bars
	// chart.selectAll("f")
	//   .data(phaseData)
	//   .enter().append("rect")
	//   .attr("x", function(d, i) {
	//     return x(d.first_compile_in_phase - 1);
	//   })
	//   .attr("y", phaseHeight)
	//   .attr("width",
	//     function(d, i) {
	//       if (d.last_compile_in_phase == compiles.length) {
	//         return x(d.last_compile_in_phase - d.first_compile_in_phase + 1);
	//       } else {
	//         return x(d.last_compile_in_phase - d.first_compile_in_phase + 2);
	//       }
	//     })
	//   .attr("height", 10)
	//   .attr("stroke", "grey")
	//   .attr("fill",
	//     function(d) {
	//       return TDDColor(d.tdd_color);
	//     })
	//   .attr("transform", "translate(" + margin.left + ",10)");

	phaseBars = chart.selectAll("f")
		.data(phases)
		.enter().append("rect")
		.attr("x", function(d, i) {
			return x(d.compiles[0] - 1);
		})
		.attr("y", phaseHeight - 20)
		.attr("width",
			function(d, i) {
				return x(d.compiles[d.compiles.length - 1] - d.compiles[0] + 1);
			})
		.attr("height", 15)
		.attr("stroke", "grey")
		.attr("fill",
			function(d) {
				return TDDColor(d.color);
			})
		.attr("transform", "translate(" + margin.left + ",10)");

	if(show_label){
		// compilesArray[0]
	chart.append("svg:text")
		.attr("x", function(d, i) {
			return x(1);
		})
		.attr("y", phaseHeight - 20)
		.attr("dy", ".35em")
		// .attr("text-anchor", "right")
		.style("font", "300 12px Helvetica Neue")
		.text("ALGORITHM")
		.attr("fill", "white")
		.attr("transform", "translate(6,18)");	
	}


}


function addNextRecordLink() {

	// var selectedSessionIndex = 0;
	// for (var i = 0; i < gon.all_sessions_markup.length; i++) {
	//   if ((gon.all_sessions_markup[i].markup.length == 0) && (gon.all_sessions_markup[i].session.id != gon.session_id)) {
	//     selectedSessionIndex = i;
	//     break;
	//   }
	// }

	// if (selectedSessionIndex == gon.all_sessions_markup.length) {
	//   console.log("no session Found");
	// } else {
	//   console.log(gon.all_sessions_markup[i]);
	//   var nSesh = gon.all_sessions_markup[i].session;
	//   var a = "";
	//   $("#nextKata").html("<a href='manualCatTool?researcher=" + gon.researcher + "&id=" + nSesh.cyberdojo_id + "&avatar=" + nSesh.avatar + "&kataName=" + nSesh.kata_name + "'>NEXT KATA</a>");
	// }

}

function createHiveData(red, green, blue) {
	if (blue == 0 || isNaN(blue)) {
		blue = 0.001;
	}
	if (red == 0 || isNaN(red)) {
		red = 0.001;
	}
	if (green == 0 || isNaN(green)) {
		green = 0.001;
	}

	var data = [{
		source: {
			x: 0,
			y0: 0.0,
			y1: red
		},
		target: {
			x: 1,
			y0: 0.0,
			y1: red
		},
		group: 3
	}, {
		source: {
			x: 1,
			y0: 0.0,
			y1: green
		},
		target: {
			x: 2,
			y0: 0.0,
			y1: green
		},
		group: 7
	}, {
		source: {
			x: 2,
			y0: 0.0,
			y1: blue
		},
		target: {
			x: 0,
			y0: 0.0,
			y1: blue
		},
		group: 11
	}];
	return data;
}

function pageSetup() {
	$(function() {

		$.ajax({
			url: "/markup/retrieve_session",
			dataType: 'json',
			data: {
				'start': 0,
				'end': 0,
				'cyberdojo_id': gon.cyberdojo_id,
				'cyberdojo_avatar': gon.cyberdojo_avatar
			},
			success: function(data) {
				populateAccordion(data);
			},
			error: function() {
				console.error("AJAX");
			},
			type: 'GET'
		});
	});
}

function buildpulseChart(TDDData) {

	TDDData.forEach(
		function(element, index) {
			curr_TDD_data = element;
			// console.log(element);

			var curr_width = $('#PulseAreaDetail').width();
			$('#PulseAreaDetail').width(curr_width + 100);
			$('#PulseAreaDetail').append("<div class='pulseChart' id='pulse"+index+"'></div>");
			var data = createHiveData(curr_TDD_data.red, curr_TDD_data.green, curr_TDD_data.blue);
			

			var my_pulsePlot =
				pulsePlot()
				.width(100)
				.height(100)
				.innerRadius(10)
				.outerRadius(50);

			d3.select("#pulse"+index)
				.datum(data)
				.call(my_pulsePlot);

			var newWidth = $("#Cycle_Area"+index).attr("width")-2;
			$("#pulse"+index).width(newWidth);
			var correctMargin = (100-newWidth)/2
			$("#pulse"+index).children().css('marginLeft', '-'+correctMargin+'px');
		})
}


function buildAggPulseChart(TDDData){

	
metrics = TDDData;
	var data = [];
  	for(var k = 0; k <metrics.length; k++){
  		currMetric = metrics[k];
  		var blue = currMetric.blue;
  		var red = currMetric.red;
  		var green = currMetric.green;
  		if(blue == 0 || isNaN(blue)){
  		blue = 0.001;
  		}
	  	if(red == 0 || isNaN(red)){
	  		red = 0.001;
	  	}
	  	if(green == 0 || isNaN(green)){
	  		green = 0.001;
	  	}
	  	data.push({source: {x: 0, y0: 0.0, y1: red}, target: {x: 1, y0: 0.0, y1: red}, group:  3});
		data.push({source: {x: 1, y0: 0.0, y1: green}, target: {x: 2, y0: 0.0, y1: green}, group:  7});
		data.push({source: {x: 2, y0: 0.0, y1: blue}, target: {x: 0, y0: 0.0, y1: blue}, group:  11});
  	}


			curr_TDD_data = TDDData[0];
			// console.log(element);
			// var metrics = mapPulseArrayToMetrics(TDDPulse, metricFunction);
			var my_pulsePlot =
				pulsePlot()
				.width(100)
				.height(100)
				.innerRadius(10)
				.outerRadius(50);

			// var curr_width = $('#PulseAreaDetail').width();
			// $('#PulseAreaDetail').width(curr_width + 100);
			$('#aggHivePlot').append("<div class='aggPulseChart' id='aggPulse'></div>");
			// var data = createHiveData(curr_TDD_data.red, curr_TDD_data.green, curr_TDD_data.blue);
			d3.select("#aggPulse")
				.datum(data)
				.call(my_pulsePlot);
	

	 //  function createAggHiveData(metrics){
  // 	var data = [];
  // 	for(var k = 0; k <metrics.length; k++){
  // 		currMetric = metrics[k];
  // 		var blue = currMetric.blue;
  // 		var red = currMetric.red;
  // 		var green = currMetric.green;
  // 		if(blue == 0 || isNaN(blue)){
  // 		blue = 0.001;
  // 		}
	 //  	if(red == 0 || isNaN(red)){
	 //  		red = 0.001;
	 //  	}
	 //  	if(green == 0 || isNaN(green)){
	 //  		green = 0.001;
	 //  	}
	 //  	data.push({source: {x: 0, y0: 0.0, y1: red}, target: {x: 1, y0: 0.0, y1: red}, group:  3});
		// data.push({source: {x: 1, y0: 0.0, y1: green}, target: {x: 2, y0: 0.0, y1: green}, group:  7});
		// data.push({source: {x: 2, y0: 0.0, y1: blue}, target: {x: 0, y0: 0.0, y1: blue}, group:  11});
  // 	}

		// return data;
  // }


}

function brushended() {
	if (!d3.event.sourceEvent) return; // only transition after input

	var extent0 = brush.extent();
	var extent1 = extent0;
	extent1[0] = Math.round(extent0[0]);
	extent1[1] = Math.round(extent0[1]);

	changeDisplayedCode(extent1);

	d3.select(this).transition()
		.call(brush.extent(extent1))
		.call(brush.event);
}


function changeDisplayedCode(extent1) {
	var start = extent1[0] - 1;
	if (start < 0) {
		start = 0;
	}
	var end = extent1[1] - 1;

	$.ajax({
		url: "/markup/retrieve_session",
		dataType: 'json',
		data: {
			'start': start,
			'end': end,
			'cyberdojo_id': gon.cyberdojo_id,
			'cyberdojo_avatar': gon.cyberdojo_avatar
		},
		success: function(data) {
			populateAccordion(data);
		},
		error: function() {
			console.error("AJAX");
		},
		type: 'GET'
	});
}

function TDDColor(color) {
	if (color == "red") {
		return "#af292e";
	} else if (color == "green") {
		return "#4e7300";
	} else if (color == "blue") {
		return "#385e86";
	} else if (color == "amber") {
		return "white";
	} else if (color == "white") {
		return "#efefef";
	} else if (color == "brown") {
		return "#49362E";
	}

}

function drawKataBackground() {
	// console.log(gon.compiles);

	phaseHeight = 10;
	lineHeight = 52;
	scaleHeight = 110;
	axisHeight = 70;
	margin = {
			top: 20,
			right: 20,
			bottom: 30,
			left: 10
		},
		width = $(window).width() - margin.left - margin.right,
		height = 300 - margin.top - margin.bottom;

	var barHeight = 50,
		color = d3.scale.category20c();

	x = d3.scale.linear()
		.domain([0, compiles.length + 1])
		.range([1, width - 40]);

	y = d3.scale.linear()
		.range([scaleHeight, scaleHeight - 10]);

	yAxis = d3.svg.axis()
		.scale(y)
		.orient("left");

	area = d3.svg.area()
		.x(function(d) {
			return x(d.date);
		})
		.y0(height)
		.y1(function(d) {
			return y(d.close);
		});


	brush = d3.svg.brush()
		.x(x)
		.extent([0, 1])
		.on("brushend", brushended);

	xAxis = d3.svg.axis()
		.scale(x)
		.orient("bottom");

	chart = d3.select(".chart")
		.attr("width", width)
		.attr("height", 100);


	// Draw Line for compile points
	var myLine = chart.append("svg:line")
		.attr("x1", x(0) + margin.left)
		.attr("y1", lineHeight)
		.attr("x2", function(d, i) {
			return x(compiles.length + 1);
		})
		.attr("y2", lineHeight)
		.style("stroke", "#737373")
		.style("stroke-width", "1");

	// Draw left start line
	var startLine = chart.append("svg:line")
		.attr("x1", margin.left + 1)
		.attr("y1", lineHeight - 6)
		.attr("x2", margin.left + 1)
		.attr("y2", lineHeight + 6)
		.style("stroke", "#737373");


	// //Draw phase bars
	// phaseBars = chart.selectAll("f")
	//   .data(phaseData)
	//   .enter().append("rect")
	//   .attr("x", function(d, i) {
	//     return x(d.first_compile_in_phase - 1);
	//   })
	//   .attr("y", phaseHeight)
	//   .attr("width",
	//     function(d, i) {
	//       if (d.last_compile_in_phase == compiles.length) {
	//         return x(d.last_compile_in_phase - d.first_compile_in_phase + 1);
	//       } else {
	//         return x(d.last_compile_in_phase - d.first_compile_in_phase + 2);
	//       }
	//     })
	//   .attr("height", 10)
	//   .attr("stroke", "grey")
	//   .attr("fill",
	//     function(d) {
	//       return TDDColor(d.tdd_color);
	//     })
	//   .attr("transform", "translate(" + margin.left + ",10)");



	// //Axis
	// var currTDDBar = chart.append("g")
	//   .attr("class", "x axis")
	//   .attr("transform", "translate(" + margin.left + ",110)")
	//   .call(xAxis)
	//   .selectAll("text")
	//   .attr("y", 6)
	//   .attr("height", 10)
	//   .style("text-anchor", "start")
	//   .style("font-size", "16px");


	// var lineFunction = d3.svg.line()
	//   .x(function(d) {
	//     // console.log(d.git_tag);
	//     return x(d.git_tag);
	//   })
	//   .y(function(d) {
	//     // console.log(d.total_test_method_count);
	//     return y(d.total_test_method_count);
	//   })
	//   .interpolate("linear");

	// //The line SVG Path we draw
	// var lineGraph = chart.append("path")
	//   .attr("d", lineFunction(data))
	//   .attr("stroke", "#737373")
	//   .attr("stroke-width", 2)
	//   .attr("fill", "#737373");

	// var gBrush = chart.append("g")
	//   .attr("class", "brush")
	//   .call(brush)
	//   .call(brush.event);

	// gBrush.selectAll("rect")
	//   .attr("height", 51)
	//   .attr("transform", "translate(" + margin.left + ",59)");


}


function drawCompilePoints() {

	//Draw Compile Points
	var bar = chart.selectAll("g")
		.data(data)
		.enter()
		.append("g");

	bar.append("rect")
		.attr("x", function(d, i) {
			return x(d.git_tag);
		})
		.attr("y", -5)
		.attr("width", 10)
		.attr("height", 10)
		.attr("r", 4)
		.attr("rx", 2.5)
		.attr("ry", 2.5)
		.attr("transform", "translate(" + margin.left + "," + lineHeight + ")")
		.attr("fill", function(d) {
			return TDDColor(d.light_color);
		})
		.attr("stroke-width", 2);

		
	// 	bar.append("text")
	// .text(function(d){
	// 	return d.total_assert_count;
	// }).attr("x", function(d, i) {
	// 		return x(d.git_tag);
	// 	})
	// 	.attr("y", -5)
	// 	.attr("width", 10)
	// 	.attr("height", 10)
	// 	.attr("transform", "translate(" + margin.left + "," + lineHeight + ")");
}

function drawAxisAndBars() {
	// //Axis
	var currTDDBar = chart.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(" + margin.left + "," + axisHeight + ")")
		.call(xAxis)
		.selectAll("text")
		.attr("y", 6)
		.attr("height", 10)
		.style("text-anchor", "start")
		.style("font-size", "16px");


	var lineFunction = d3.svg.line()
		.x(function(d) {
			// console.log(d.git_tag);
			return x(d.git_tag);
		})
		.y(function(d) {
			// console.log(d.total_test_method_count);
			return y(d.total_test_method_count);
		})
		.interpolate("linear");

	//The line SVG Path we draw
	var lineGraph = chart.append("path")
		.attr("d", lineFunction(data))
		.attr("stroke", "#737373")
		.attr("stroke-width", 2)
		.attr("fill", "#737373");

	// var gBrush = chart.append("g")
	// 	.attr("class", "brush")
	// 	.call(brush)
	// 	.call(brush.event);

	// gBrush.selectAll("rect")
	// 	.attr("height", 70)
	// 	.attr("transform", "translate(" + margin.left + ",0)");


}

function drawChartRect(){
	var gBrush = chart.append("g")
		.attr("class", "brush")
		.call(brush)
		.call(brush.event);

	gBrush.selectAll("rect")
		.attr("height", 70)
		.attr("transform", "translate(" + margin.left + ",0)");

}

function drawEachUserMarkups(AllMarkups) {

	var offset = 0;

	$.each(AllMarkups, function(i, item) {

		phaseBars = chart.selectAll("f")
			.data(item)
			.enter().append("rect")
			.attr("x", function(d, i) {
				return x(d.first_compile_in_phase);
			})
			.attr("y", phaseHeight + offset)
			.attr("width",
				function(d, i) {
					return x(d.last_compile_in_phase - d.first_compile_in_phase);
				})
			.attr("height", 15)
			.attr("stroke", "grey")
			.attr("fill",
				function(d) {
					return TDDColor(d.tdd_color);
				})
			.attr("transform", "translate(" + margin.left + ",10)");

		// compilesArray[0]
		chart.append("svg:text")
			.attr("x", function(d, i) {
				return x(1);
			})
			.attr("y", phaseHeight + offset)
			.attr("dy", ".35em")
			// .attr("text-anchor", "right")
			.style("font", "300 12px Helvetica Neue")
			.text(i)
			.attr("fill", "white")
			.attr("transform", "translate(6,18)");

		offset = offset + 20;

	});
}


function highlightDiffs(AllMarkups) {
	// console.log(AllMarkups);

	var compilesArray = new Array(compiles.length);
	for (var i = 0; i < compiles.length + 1; i++) {
		compilesArray[i] = new Array();
	}
	$.each(AllMarkups, function(i, item) {
		// console.log(item);
		$.each(item, function(j, phase) {
			// console.log(phase);
			for (var k = phase.first_compile_in_phase; k < phase.last_compile_in_phase; k++) {
				compilesArray[k][i] = phase.tdd_color;
			}
		});

	});
	console.log(compilesArray);

	diffBoxes = chart.selectAll("f")
		.data(compilesArray)
		.enter().append("rect")
		.attr("x", function(d, i) {
			return x(i);
		})
		.attr("y", 10)
		.attr("width", function(d, i) {
			return x(1);
		})
		.attr("height", 150)
		.attr("stroke", "grey")
		.attr("fill", function(d, i) {
			// return x(1);
			var ArrayOfKeys = Object.keys(d)
			var initialValue = d[ArrayOfKeys[0]];
			var isEqual = true;
			for (var j = 1; j < ArrayOfKeys.length; j++) {
				if (d[ArrayOfKeys[j]] != initialValue) {
					isEqual = false;
				}
			}
			if (isEqual) {
				return "green";
			} else {
				return "red";
			}
		})
		.attr("opacity", .08)
		.attr("transform", "translate(" + margin.left + ",10)");
	// offset = offset + 20;

}

function drawUncatagorizedKata() {

	// console.log(gon.compiles);

	phaseHeight = 10;
	var lineHeight = 50;
	var scaleHeight = 110;
	margin = {
			top: 20,
			right: 20,
			bottom: 30,
			left: 10
		},
		width = $(window).width() - margin.left - margin.right,
		height = 100 - margin.top - margin.bottom;

	var barHeight = 50,
		color = d3.scale.category20c();

	x = d3.scale.linear()
		.domain([0, compiles.length + 1])
		.range([1, width - 40]);

	var y = d3.scale.linear()
		// .domain([0, data[data.length-2].total_assert_count])
		.range([scaleHeight, scaleHeight - 10]);

	var yAxis = d3.svg.axis()
		.scale(y)
		.orient("left");

	var area = d3.svg.area()
		.x(function(d) {
			return x(d.date);
		})
		.y0(height)
		.y1(function(d) {
			return y(d.close);
		});


	brush = d3.svg.brush()
		.x(x)
		.extent([0, 1])
		.on("brushend", brushended);

	var xAxis = d3.svg.axis()
		.scale(x)
		.orient("bottom");

	chart = d3.select(".chart")
		.attr("width", width)
		.attr("height", barHeight * 3);


	// Draw Line for compile points
	var myLine = chart.append("svg:line")
		.attr("x1", margin.left)
		.attr("y1", lineHeight)
		.attr("x2", function(d, i) {
			return x(compiles.length) + 5;
		})
		.attr("y2", lineHeight)
		.style("stroke", "#737373")
		.style("stroke-width", "1");

	// Draw left start line
	var startLine = chart.append("svg:line")
		.attr("x1", margin.left + 1)
		.attr("y1", lineHeight - 6)
		.attr("x2", margin.left + 1)
		.attr("y2", lineHeight + 6)
		.style("stroke", "#737373");


	//Draw phase bars
	phaseBars = chart.selectAll("f")
		.data(phaseData)
		.enter().append("rect")
		.attr("x", function(d, i) {
			return x(d.first_compile_in_phase - 1);
		})
		.attr("y", phaseHeight)
		.attr("width",
			function(d, i) {
				if (d.last_compile_in_phase == compiles.length) {
					return x(d.last_compile_in_phase - d.first_compile_in_phase + 1);
				} else {
					// return x(d.last_compile_in_phase - d.first_compile_in_phase + 2);
				}
			})
		.attr("height", 10)
		.attr("stroke", "grey")
		.attr("fill",
			function(d) {
				return TDDColor(d.tdd_color);
			})
		.attr("transform", "translate(" + margin.left + ",10)");



	//Draw Compile Points
	var bar = chart.selectAll("g")
		.data(data)
		.enter().append("g");

	bar.append("rect")
		.attr("x", function(d, i) {
			return x(d.git_tag);
		})
		.attr("y", -5)
		.attr("width", 10)
		.attr("height", 10)
		.attr("r", 4)
		.attr("rx", 2.5)
		.attr("ry", 2.5)
		.attr("transform", "translate(" + margin.left + "," + lineHeight + ")")
		.attr("fill", function(d) {
			return TDDColor(d.light_color);
		})
		.attr("stroke-width", 2);


		bar.append("text")
	.text(function(d){
		return d.total_assert_count;
	}).attr("x", function(d, i) {
			return x(d.git_tag);
		})
		.attr("y", -5)
		.attr("width", 10)
		.attr("height", 10)
		.attr("transform", "translate(" + margin.left + "," + lineHeight + ")");

	//Axis
	var currTDDBar = chart.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(" + margin.left + ",110)")
		.call(xAxis)
		.selectAll("text")
		.attr("y", 6)
		.attr("height", 10)
		.style("text-anchor", "start")
		.style("font-size", "16px");


  // var lineFunction = d3.svg.line()
  //   .x(function(d) {
  //     // console.log(d.git_tag);
  //     return x(d.git_tag);
  //   })
  //   .y(function(d) {
  //     // console.log(d.total_test_method_count);
  //     return y(d.total_assert_count);
  //   })
  //   .interpolate("linear");

  // //The line SVG Path we draw
  // var lineGraph = chart.append("path")
  //   .attr("d", lineFunction(data))
  //   .attr("stroke", "#737373")
  //   .attr("stroke-width", 2)
  //   .attr("fill", "#737373");


	// chart.selectAll("h")
	//    .data(cycles)
	//    .enter().append("rect")
	//    .attr("x", function(d, i) {
	//      return x(d.startCompile - 1);
	//    })
	//    .attr("y", 20)
	//    .attr("width",
	//      function(d, i) {
	//        return x(d.endCompile - d.startCompile + 1);
	//      })
	//    .attr("height", 40)
	//    .attr("rx", 6)
	//    .attr("ry", 6)
	//    .attr("stroke", "grey")
	//    .attr("fill", function(d) {
	//      if (d.valid_tdd == true) {
	//        return "#BABABA";
	//      }
	//      if (d.valid_tdd == false) {
	//        return "#6F6F6F";
	//      }

	//    })
	//    .attr("transform", "translate(" + margin.left + ",-10)");




  // //The line SVG Path we draw
  // var lineGraph = chart.append("path")
  //   .attr("d", lineFunction(data))
  //   .attr("stroke", "#737373")
  //   .attr("stroke-width", 2)
  //   .attr("fill", "#737373");

	var gBrush = chart.append("g")
		.attr("class", "brush")
		.call(brush)
		.call(brush.event);

	gBrush.selectAll("rect")
		.attr("height", 51)
		.attr("transform", "translate(" + margin.left + ",59)");
}


function drawallMarkups() {

	// console.log(gon.compiles);

	phaseHeight = 10;
	var lineHeight = 50;
	var scaleHeight = 110;
	margin = {
			top: 20,
			right: 20,
			bottom: 30,
			left: 10
		},
		width = $(window).width() - margin.left - margin.right,
		height = 100 - margin.top - margin.bottom;

	var barHeight = 50,
		color = d3.scale.category20c();

	x = d3.scale.linear()
		.domain([0, compiles.length])
		.range([1, width - 40]);

	var y = d3.scale.linear()
		.range([scaleHeight, scaleHeight - 10]);

	var yAxis = d3.svg.axis()
		.scale(y)
		.orient("left");

	var area = d3.svg.area()
		.x(function(d) {
			return x(d.date);
		})
		.y0(height)
		.y1(function(d) {
			return y(d.close);
		});


	brush = d3.svg.brush()
		.x(x)
		.extent([0, 1])
		.on("brushend", brushended);

	var xAxis = d3.svg.axis()
		.scale(x)
		.orient("bottom");

	chart = d3.select(".chart")
		.attr("width", width)
		.attr("height", barHeight * 3);


	// Draw Line for compile points
	var myLine = chart.append("svg:line")
		.attr("x1", margin.left)
		.attr("y1", lineHeight)
		.attr("x2", function(d, i) {
			return x(compiles.length) + 5;
		})
		.attr("y2", lineHeight)
		.style("stroke", "#737373")
		.style("stroke-width", "1");

	// Draw left start line
	var startLine = chart.append("svg:line")
		.attr("x1", margin.left + 1)
		.attr("y1", lineHeight - 6)
		.attr("x2", margin.left + 1)
		.attr("y2", lineHeight + 6)
		.style("stroke", "#737373");


	//Draw phase bars
	phaseBars = chart.selectAll("f")
		.data(phaseData)
		.enter().append("rect")
		.attr("x", function(d, i) {
			return x(d.first_compile_in_phase - 1);
		})
		.attr("y", phaseHeight)
		.attr("width",
			function(d, i) {
				if (d.last_compile_in_phase == compiles.length) {
					return x(d.last_compile_in_phase - d.first_compile_in_phase + 1);
				} else {
					return x(d.last_compile_in_phase - d.first_compile_in_phase + 2);
				}
			})
		.attr("height", 10)
		.attr("stroke", "grey")
		.attr("fill",
			function(d) {
				return TDDColor(d.tdd_color);
			})
		.attr("transform", "translate(" + margin.left + ",10)");



	//Draw Compile Points
	var bar = chart.selectAll("g")
		.data(data)
		.enter()
		.append("g");

	bar.append("rect")
		.attr("x", function(d, i) {
			return x(d.git_tag);
		})
		.attr("y", -5)
		.attr("width", 10)
		.attr("height", 10)
		.attr("r", 4)
		.attr("rx", 2.5)
		.attr("ry", 2.5)
		.attr("transform", "translate(" + margin.left + "," + lineHeight + ")")
		.attr("fill", function(d) {
			return TDDColor(d.light_color);
		})
		.attr("stroke-width", 2);


		bar.append("text")
	.text(function(d){
		return d.total_assert_count;
	}).attr("x", function(d, i) {
			return x(d.git_tag);
		})
		.attr("y", -5)
		.attr("width", 10)
		.attr("height", 10)
		.attr("transform", "translate(" + margin.left + "," + lineHeight + ")");

	//Axis
	var currTDDBar = chart.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(" + margin.left + ",110)")
		.call(xAxis)
		.selectAll("text")
		.attr("y", 6)
		.attr("height", 10)
		.style("text-anchor", "start")
		.style("font-size", "16px");


	var lineFunction = d3.svg.line()
		.x(function(d) {
			// console.log(d.git_tag);
			return x(d.git_tag);
		})
		.y(function(d) {
			// console.log(d.total_test_method_count);
			return y(d.total_test_method_count);
		})
		.interpolate("linear");

	//The line SVG Path we draw
	var lineGraph = chart.append("path")
		.attr("d", lineFunction(data))
		.attr("stroke", "#737373")
		.attr("stroke-width", 2)
		.attr("fill", "#737373");

	var gBrush = chart.append("g")
		.attr("class", "brush")
		.call(brush)
		.call(brush.event);

	gBrush.selectAll("rect")
		.attr("height", 51)
		.attr("transform", "translate(" + margin.left + ",59)");
}


function drawKataViz() {

	// console.log(gon.compiles);

	var phaseHeight = 50;
	var lineHeight = 90;
	var margin = {
			top: 20,
			right: 20,
			bottom: 30,
			left: 10
		},
		width = $(window).width() - margin.left - margin.right,
		height = 100 - margin.top - margin.bottom;

	var barHeight = 50,
		color = d3.scale.category20c();

	var x = d3.scale.linear()
		.domain([0, compiles.length])
		.range([1, width - 40]);

	brush = d3.svg.brush()
		.x(x)
		.extent([3, 5])
		.on("brushend", brushended);

	var xAxis = d3.svg.axis()
		.scale(x)
		.orient("bottom");

	var chart = d3.select(".chart")
		.attr("width", width)
		.attr("height", barHeight * 3);


	// Draw Line for compile points
	var myLine = chart.append("svg:line")
		.attr("x1", margin.left)
		.attr("y1", lineHeight)
		.attr("x2", function(d, i) {
			return x(compiles.length) + 5;
		})
		.attr("y2", lineHeight)
		.style("stroke", "#737373")
		.style("stroke-width", "1");

	// Draw left start line
	var startLine = chart.append("svg:line")
		.attr("x1", margin.left + 1)
		.attr("y1", lineHeight - 6)
		.attr("x2", margin.left + 1)
		.attr("y2", lineHeight + 6)
		.style("stroke", "#737373");



	// TODO WHY IS THIS BREAKING?
	chart.append("g")
		.data(cycles)
		.enter().append("rect")
		.attr("x", function(d, i) {
			// return x(d.startCompile - 1);
			return x(d.all_phases[0].compiles[0]);
		})
		.attr("y", 20)
		.attr("width",
			function(d, i) {
				// return x(d.endCompile - d.startCompile + 1);
				return x(d.all_phases[d.all_phases.length-1].compiles[d.all_phases[d.all_phases.length-1].compiles.length-1] -  d.all_phases[0].compiles[0])
			})
		.attr("height", 40)
		.attr("rx", 6)
		.attr("ry", 6)
		.attr("stroke", "grey")
		.attr("fill", function(d) {
			if (d.valid_tdd == true) {
				return "#BABABA";
			}
			if (d.valid_tdd == false) {
				return "#6F6F6F";
			}

		})
		.attr("transform", "translate(" + margin.left + ",-10)");





	//Draw phase bars
	chart.selectAll("f")
		.data(phaseData)
		.enter().append("rect")
		.attr("x", function(d, i) {
			return x(d.compiles[0]);
		})
		.attr("y", phaseHeight - 10)
		.attr("width",
			function(d, i) {
				return x(d.compiles[d.compiles.length - 1] - d.compiles[0] + 1);
			})
		.attr("height", 15)
		.attr("stroke", "grey")
		.attr("fill",
			function(d) {
				return TDDColor(d.color);
			})
		.attr("transform", "translate(" + margin.left + ",10)");



	//Draw Compile Points
	var bar = chart.selectAll("g")
		.data(data)
		.enter().append("g");

	// bar.append("circle")
	//   .attr("cx", function(d, i) {
	//     return x(d.git_tag);
	//   })
	//   .attr("r", 4)
	//   .attr("transform", "translate(" + margin.left + "," + lineHeight + ")")
	//   .attr("fill", function(d) {
	//     return TDDColor(d.light_color);
	//   })
	//   .attr("stroke-width", 2);

	bar.append("rect")
		.attr("x", function(d, i) {
			return x(d.git_tag);
		})
		.attr("y", -5)
		.attr("width", 10)
		.attr("height", 10)
		.attr("r", 4)
		.attr("rx", 2.5)
		.attr("ry", 2.5)
		.attr("transform", "translate(" + margin.left + "," + lineHeight + ")")
		.attr("fill", function(d) {
			return TDDColor(d.light_color);
		})
		.attr("stroke-width", 2);


		bar.append("text")
	.text(function(d){
		return d.total_assert_count;
	}).attr("x", function(d, i) {
			return x(d.git_tag);
		})
		.attr("y", -5)
		.attr("width", 10)
		.attr("height", 10)
		.attr("transform", "translate(" + margin.left + "," + lineHeight + ")");

	var currTDDBar = chart.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(" + margin.left + ",110)")
		.call(xAxis)
		.selectAll("text")
		.attr("y", 6)
		.attr("height", 10)
		// .attr("x", 6)
		.style("text-anchor", "start")
		.style("font-size", "16px");





	//START HIVE PLOT
	// selection.each(function(data) {

	//       var margin = {top: 20, right: 20, bottom: 30, left: 50},
	//   width = 200,
	//     height = 200,
	//     innerRadius = 10,
	//     outerRadius = 100;


	//  var hive_data = createHiveData(TDDData[0].red, TDDData[0].green, TDDData[0].blue);

	//     var opacity = 3/ hive_data.length ;

	//     var angle = d3.scale.ordinal().domain(d3.range(4)).rangePoints([0, 2 * Math.PI]),
	//     radius = d3.scale.linear().range([innerRadius, outerRadius]),
	//     color = d3.scale.ordinal().range(["#af292e","#4e7300","#385e86"]);

	// var hive = chart.selectAll("i")
	// .data(hive_data)
	// .enter()
	// .append("i");

	//     // Select the svg element, if it exists.
	//       // var svg = currTDDBar.data([hive_data]);

	//       // Otherwise, create the skeletal chart.
	//       // var gEnter = svg.enter().append("svg").append("g");

	//       // Update the outer dimensions.
	//       // svg .attr("width", width)
	//       //     .attr("height", height);

	//       // Update the inner dimensions.
	//       var i = hive.select("i")
	//           .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

	//     i.selectAll(".link")
	//       .data(hive_data)
	//     .enter().append("path")
	//       .attr("class", "link")
	//       .attr("d", d3.hive.link()
	//       .angle(function(d) { 
	//         return angle(d.x);
	//       })
	//       .startRadius(function(d) { 
	//         return radius(d.y0); })
	//       .endRadius(function(d) { return radius(d.y1); 
	//       }))
	//       .style("fill", function(d) { return color(d.group);
	//     }).style("opacity",opacity);

	//       //END HIVEPLOT


	// //setup for plot
	//   var my_pulsePlot =
	//     pulsePlot()
	//     .width(100)
	//     .height(100)
	//     .innerRadius(10)
	//     .outerRadius(50)
	//     .attr("transform", "translate(" + margin.left + "," + lineHeight + ")");

	// //put on page
	//   // $('#PulseAreaDetail').append("<div class='pulseChart' id='pulse'></div>");
	//   var data = createHiveData(TDDData[0].red, TDDData[0].green, TDDData[0].blue);
	//   d3.select("#pulse")
	//     .datum(data)
	//     .call(my_pulsePlot);



	// //Draw Compile Points
	//   var cycleBars = chart.selectAll("h")
	//     .data(cycles)
	//     .enter().append("h");

	//   // cycleBars.append("circle")
	//   //   .attr("cx", function(d, i) {
	//   //     return x(d.git_tag);
	//   //   })
	//   //   .attr("r", 4)
	//   //   .attr("transform", "translate(" + margin.left + ",1)")
	//   //   .attr("fill", "black")
	//   //   .attr("stroke-width", 2);


	//   //     var cycleBoxes = chart.selectAll("h")
	//   //     .data(cycles)
	//   //     .enter().append("h");
	//   //     //  .attr("transform", function(d, i) { 
	//   //     //   return "translate(10,10)"; 
	//   //     // });

	//   cycleBars.append("rect")
	//    .attr("x", function(d, i) {
	//         return x(d.startCompile - 1);
	//       })
	//       .attr("y", 10)
	//       .attr("width",
	//         function(d, i) {
	//           if (d.endCompile == compiles.length) {
	//             return x(d.endCompile - d.startCompile + 1);
	//           } else {
	//             return x(d.endCompile - d.startCompile + 2);
	//           }
	//         })
	//       .attr("height", 10)
	//       .attr("stroke", "grey")
	//       .attr("fill","orange");
	//   //     // .attr("transform", "translate(" + margin.left + ",10)");

	// //TODO WHY IS THIS BREAKING?
	//   chart.append("g")
	//     .data(cycles)
	//     .enter().append("rect")
	//     .attr("x", function(d, i) {
	//       return x(d.startCompile - 1);
	//     })
	//     .attr("y", 20)
	//     .attr("width",
	//       function(d, i) {
	//         return x(d.endCompile - d.startCompile + 1);
	//       })
	//     .attr("height", 40)
	//     .attr("rx", 6)
	//     .attr("ry", 6)
	//     .attr("stroke", "grey")
	//     .attr("fill", function(d) {
	//       if (d.valid_tdd == true) {
	//         return "#BABABA";
	//       }
	//       if (d.valid_tdd == false) {
	//         return "#6F6F6F";
	//       }

	//     })
	//     .attr("transform", "translate(" + margin.left + ",-10)");



	// chart.selectAll("h")
	//   .data(cycles)
	//   .enter().append("rect")
	//   .attr("x", function(d, i) {
	//     return x(d.startCompile - 1);
	//   })
	//   .attr("y", 10)
	//   .attr("width",
	//     function(d, i) {
	//       if (d.endCompile == compiles.length) {
	//         return x(d.endCompile - d.startCompile + 1);
	//       } else {
	//         return x(d.endCompile - d.startCompile + 2);
	//       }
	//     })
	//   .attr("height", 10)
	//   .attr("stroke", "grey")
	//   .attr("fill", function(d) {
	//     if (d.valid_tdd == "true") {
	//       return "orange";
	//     }
	//       return "green";

	//   })
	// .attr("transform", "translate(" + margin.left + ",10)");



	// endCompile: 15 
	//startCompile: 1
	//valid_tdd: true


	// //Draw phase bars
	//   chart.selectAll("f")
	//     .data(phaseData)
	//     .enter().append("rect")
	//     .attr("x", function(d, i) {
	//       return x(d.first_compile_in_phase - 1);
	//     })
	//     .attr("y", phaseHeight)
	//     .attr("width",
	//       function(d, i) {
	//         if (d.last_compile_in_phase == compiles.length) {
	//           return x(d.last_compile_in_phase - d.first_compile_in_phase + 1);
	//         } else {
	//           return x(d.last_compile_in_phase - d.first_compile_in_phase + 2);
	//         }
	//       })
	//     .attr("height", 10)
	//     .attr("stroke", "grey")
	//     .attr("fill",
	//       function(d) {
	//         return TDDColor(d.tdd_color);
	//       })
	//     .attr("transform", "translate(" + margin.left + ",10)");



	var gBrush = chart.append("g")
		.attr("class", "brush")
		.call(brush)
		.call(brush.event);

	gBrush.selectAll("rect")
		.attr("height", 51)
		.attr("transform", "translate(" + margin.left + ",59)");



}


function populateAccordion(data) {
	var commonFiles = [];
	var uniqueStart = [];
	var uniqueEnd = [];
	for (var start_key in data.start) {
		var found = 0;
		for (var end_key in data.end) {
			if (start_key == end_key) {
				commonFiles.push(start_key)
				found = 1;
			}
		}
		if (found < 1) {
			uniqueStart.push(start_key)
		}
	}

	for (var end_key in data.end) {
		if (commonFiles.indexOf(end_key) < 0) {
			uniqueEnd.push(end_key);
		}
	}

	$('#accordion').html("");

	//Add Common Files
	commonFiles
		.forEach(
			function(element, index) {
				var str1 = data.start[element];
				var str2 = data.end[element];
				addTitleAndDiffCode(str1, str2, element);
			})
		//Add unique start files
	uniqueStart.forEach(
		function(element, index) {
			var str1 = data.start[element];
			//THis will make the diff clear that the file was removed
			var str2 = "";
			addTitleAndDiffCode(str1, str2, element);
		})

	//Add unique end files
	uniqueEnd.forEach(
		function(element, index) {
			var str1 = "";
			var str2 = data.end[element];
			addTitleAndDiffCode(str1, str2, element);
		})
	$("#accordion").height($(window).height() - $("#header").height() - 20);
}


function addTitleAndDiffCode(str1, str2, element) {

	var safeName = element.replace('.', '');

	var newDiv = "<div class='entireDiffArea'><div class='diffTitle' id='" + safeName + "'>" + element + "<\/div><div class='diffArea'><div id='compare_" + safeName + "' class='CodeMirror'></div></div></div></div></div>";
	$('#accordion').append(newDiv);

	$('#compare_' + safeName)
		.mergely({
			// width: ($(window).width/2),
			// height: 500,
			width: $(window).width() - ($(window).width() * 0.05),
			autoresize: true,
			sidebar: false,
			cmsettings: {
				readOnly: true,
				lineNumbers: true,
				mode: "text/x-java"
			},
			lhs: function(setValue) {
				setValue(str1);
			},
			rhs: function(setValue) {
				setValue(str2);
			}
		});
	var diffLength = $('#compare_' + safeName).mergely('diff').split(/\r\n|\r|\n/).length;
	if (diffLength == 1) {
		$("#compare_" + safeName).css("display", "none");
		$("#" + safeName).addClass("collapsed");
		$("#" + safeName).click(expand);
	} else {
		$("#" + safeName).click(collapse);
	}

	$('#' + safeName).html(element + " ID:" +  gon.session_id + " Loc:"+ currLocation +" ChangeValue:" + (diffLength - 1) );

	// $('#compare_' + safeName).mergely('resize')
}

function collapse(e) {
	$("#compare_" + e.currentTarget.id).css("display", "none");
	$("#" + e.currentTarget.id).click(expand);
}

function expand(e) {
	$("#compare_" + e.currentTarget.id).css("display", "inline");
	$("#" + e.currentTarget.id).click(collapse);
}

function checkLogin() {

	$("#logout").click(function() {
		$.removeCookie('username', {
			path: '/'
		});
		location.reload();
	});

	$('#username').html("Hello " + username);
}

function redrawPhaseBars() {
	// phaseBars.exit().remove();
	phaseBars.remove();

	// console.log("redrawPhaseBars");
	//Draw phase bars
	phaseBars = chart.selectAll(".phase")
		.data(phaseData)
		.enter().append("g");

	phaseBars.append("rect")
		.attr("x", function(d, i) {
			return x(d.first_compile_in_phase);
		})
		.attr("y", phaseHeight)
		.attr("width",
			function(d, i) {
				return x(d.last_compile_in_phase - d.first_compile_in_phase);
			})
		.attr("height", 15)
		.attr("stroke", "grey")
		.attr("fill",
			function(d) {
				return TDDColor(d.tdd_color);
			})
		.attr("transform", "translate(" + margin.left + ",10)");
}

function saveMarkup() {

	phaseDataJSON = {
		phaseData: phaseData,
		cyberdojo_id: gon.cyberdojo_id,
		cyberdojo_avatar: gon.cyberdojo_avatar
	};

	$.ajax({
		url: 'store_markup',
		type: 'post',
		data: phaseDataJSON,
		dataType: 'JSON',
		error: function() {
			console.error("AJAX");
		}
	});
}

function saveNewPhase(start, end, color) {

	phaseDataJSON = {
		phaseData: {
			start: start,
			end: end,
			color: color
		},
		cyberdojo_id: gon.cyberdojo_id,
		cyberdojo_avatar: gon.cyberdojo_avatar,
		// user: $.cookie('username')
		user: username
	};

	$.ajax({
		url: 'store_markup',
		type: 'post',
		data: phaseDataJSON,
		dataType: 'JSON',
		error: function() {
			console.error("AJAX");
		}
	});
}


function addNewPhase(start, end, color) {
	var newPhase = new Object();

	for (var i = (phaseData.length - 1); i >= 0; --i) {
		var startsInsideRange = false;
		var finishesInsideRange = false;
		var coversRange = false;

		if (start == phaseData[i].first_compile_in_phase) {
			if (end == phaseData[i].last_compile_in_phase) {
				//EXACT MATCH
				updatePhase(start, end, phaseData[i].first_compile_in_phase, phaseData[i].last_compile_in_phase, phaseData[i].tdd_color, color);
				redrawPhaseBars();
				return;
			} else if (end > phaseData[i].last_compile_in_phase) {
				//Entirely Contained
				deletePhase(phaseData[i], i);
				phaseData.splice(i, 1);
			} else if (end < phaseData[i].last_compile_in_phase) {
				//Extends beyond
				updatePhase(end, phaseData[i].last_compile_in_phase, phaseData[i].first_compile_in_phase, phaseData[i].last_compile_in_phase, phaseData[i].tdd_color);
			}
		} else if (start < phaseData[i].first_compile_in_phase) {
			if ((end >= phaseData[i].last_compile_in_phase)) {
				// OVERWRITE PHASE
				deletePhase(phaseData[i], i);
				phaseData.splice(i, 1);
			} else if ((end < phaseData[i].last_compile_in_phase) && (end > phaseData[i].firstw_compile_in_phase)) {
				// MODIFY PHASE
				updatePhase(end, phaseData[i].last_compile_in_phase, phaseData[i].first_compile_in_phase, phaseData[i].last_compile_in_phase, phaseData[i].tdd_color);
			}
		} else if (start > phaseData[i].first_compile_in_phase) {
			if ((end >= phaseData[i].last_compile_in_phase) && (start < phaseData[i].last_compile_in_phase)) {
				//MODIFY PHASE
				updatePhase(phaseData[i].first_compile_in_phase, start, phaseData[i].first_compile_in_phase, phaseData[i].last_compile_in_phase, phaseData[i].tdd_color);
			} else if (end < phaseData[i].last_compile_in_phase) {
				//SPLIT PHASE
				addNewPhase(end, phaseData[i].last_compile_in_phase, phaseData[i].tdd_color);
				updatePhase(phaseData[i].first_compile_in_phase, start, phaseData[i].first_compile_in_phase, phaseData[i].last_compile_in_phase, phaseData[i].tdd_color)
			}
		}
	}

	newPhase.first_compile_in_phase = start;
	newPhase.last_compile_in_phase = end;
	newPhase.tdd_color = color;
	phaseData.push(newPhase);
	redrawPhaseBars();
	saveNewPhase(start, end, color);
}



function updatePhase(newStart, newEnd, oldStart, oldEnd, oldColor, newColor) {
	console.log("TODO update phase");
	console.log("newStart: " + newStart);
	console.log("newEnd: " + newEnd);
	console.log("oldStart: " + oldStart);
	console.log("oldEnd: " + oldEnd);
	console.log("color: " + oldColor);
	if (newColor == null) {
		newColor = oldColor;
	}

	//Update data locally
	for (var i = 0; i < phaseData.length; i++) {
		if (phaseData[i].first_compile_in_phase == oldStart) {
			if (phaseData[i].last_compile_in_phase == oldEnd) {
				// if (phaseData[i].tdd_color == oldColor) {
				phaseData[i].first_compile_in_phase = newStart;
				phaseData[i].last_compile_in_phase = newEnd;
				phaseData[i].tdd_color = newColor;
				break;
				// }
			}
		}
	}

	//Update data on server
	phaseDataJSON = {
		phaseData: {
			oldStart: oldStart,
			oldEnd: oldEnd,
			newStart: newStart,
			newEnd: newEnd,
			oldColor: oldColor,
			newColor: newColor
		},
		cyberdojo_id: gon.cyberdojo_id,
		cyberdojo_avatar: gon.cyberdojo_avatar,
		user: username
	};

	$.ajax({
		url: 'update_markup',
		type: 'post',
		data: phaseDataJSON,
		dataType: 'JSON'
	});


}

function deleteMatchingPhases(start, end) {
	for (var i = phaseData.length; i--; i > 0) {
		console.log(phaseData[i]);
		currStart = phaseData[i].first_compile_in_phase
		currEnd = phaseData[i].last_compile_in_phase
		if (currStart >= start && currStart < end) {
			deletePhase(phaseData[i], i);
		} else if (currEnd > start && currEnd <= end) {
			deletePhase(phaseData[i], i);
		}
	}
	redrawPhaseBars();

}

function deletePhase(currPhase, i) {

	phaseDataJSON = {
		phaseData: {
			start: currPhase.first_compile_in_phase,
			end: currPhase.last_compile_in_phase,
			color: currPhase.tdd_color
		},
		cyberdojo_id: gon.cyberdojo_id,
		cyberdojo_avatar: gon.cyberdojo_avatar,
		user: username
	};

	phaseData.splice(i, 1);
	$.ajax({
		url: 'del_markup',
		type: 'post',
		data: phaseDataJSON,
		dataType: 'JSON',
		error: function() {
			console.error("AJAX");
		}
	});

}

function addAllPrexistingMarkup(markupArr) {
	if (markupArr == undefined) {
		return;
	}
	markupArr.forEach(function(element, index, array) {
		// console.log(element.tdd_color);
		phaseData.push(element);
		// redrawPhaseBars();

	});
	redrawPhaseBars();
}

function initializeKeyBindings() {

	// console.log("INIT BINDINGS");
	$(document).keydown(function(e) {
		// console.log(e.which);
		switch (e.which) {
			case 65: //a
				addNewPhase(brush.extent()[0], brush.extent()[1], "red");
				break;

			case 83: //s
				addNewPhase(brush.extent()[0], brush.extent()[1], "green");
				break;

			case 68: //d
				addNewPhase(brush.extent()[0], brush.extent()[1], "blue");
				break;

			case 70: //f
				addNewPhase(brush.extent()[0], brush.extent()[1], "white");
				break;

			case 71: //g
				addNewPhase(brush.extent()[0], brush.extent()[1], "brown");
				break;

			case 37: // left
				if (brush.extent()[0] < 1) {
					break
				}
				if (brush.extent()[0] >= brush.extent()[1]) {
					break
				}
				if (e.shiftKey) {
					currLocation = brush.extent();
					brush.extent([currLocation[0] - 1, currLocation[1]]);
					brush(d3.select(".brush").transition());
				} else if (e.altKey) {
					currLocation = brush.extent();
					brush.extent([currLocation[0], currLocation[1] - 1]);
					brush(d3.select(".brush").transition());
				} else {
					currLocation = brush.extent();
					brush.extent([currLocation[0] - 1, currLocation[1] - 1]);
					brush(d3.select(".brush").transition());
				}
				changeDisplayedCode(brush.extent());
				break;

			case 38: // up
				break;

			case 39: // right
				if (brush.extent()[1] > (gon.compiles.length - 1)) {
					break
				}
				if (brush.extent()[1] <= brush.extent()[0]) {
					break
				}
				if (e.shiftKey) {
					currLocation = brush.extent();
					brush.extent([currLocation[0], currLocation[1] + 1]);
					brush(d3.select(".brush").transition());
				} else if (e.altKey) {
					currLocation = brush.extent();
					brush.extent([currLocation[0] + 1, currLocation[1]]);
					brush(d3.select(".brush").transition());
				} else {
					currLocation = brush.extent();
					brush.extent([currLocation[0] + 1, currLocation[1] + 1]);
					brush(d3.select(".brush").transition());
				}
				changeDisplayedCode(brush.extent());
				break;

			case 40: // down
				break;

			case 88: // x
				currLocation = brush.extent();
				deleteMatchingPhases(brush.extent()[0], brush.extent()[1]);
				// phaseBars.data(phaseData).exit().remove();
				break;

			default:
				return; // exit this handler for other keys
		}

		e.preventDefault(); // prevent the default action (scroll / move caret)
	});

}
