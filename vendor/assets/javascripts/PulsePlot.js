function pulsePlot() {

var margin = {top: 20, right: 20, bottom: 30, left: 50},
 	width = 200,
    height = 200,
    innerRadius = 10,
    outerRadius = 100,
    click = function(){},
    hover = function(){};

	var chart = function(selection){
	  //draw the chart
	  selection.each(function(data) {


	  var opacity = 3/ data.length ;

	  var angle = d3.scale.ordinal().domain(d3.range(4)).rangePoints([0, 2 * Math.PI]),
	  radius = d3.scale.linear().range([innerRadius, outerRadius]),
	  color = d3.scale.ordinal().range(["#af292e","#4e7300","#385e86"]);

	  // Select the svg element, if it exists.
      var svg = d3.select(this).selectAll("svg").data([data]);

      // Otherwise, create the skeletal chart.
      var gEnter = svg.enter().append("svg").append("g");

      // Update the outer dimensions.
      svg .attr("width", width)
          .attr("height", height);

      // Update the inner dimensions.
      var g = svg.select("g")
          .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

	  g.selectAll(".link")
	    .data(data)
	  .enter().append("path")
	    .attr("class", "link")
	    .attr("d", d3.hive.link()
	    .angle(function(d) { 
	    	return angle(d.x);
	    })
	    .startRadius(function(d) { 
	    	return radius(d.y0); })
	    .endRadius(function(d) { return radius(d.y1); 
	    }))
	    .style("fill", function(d) { return color(d.group);
	  }).style("opacity",opacity);

	g.selectAll(".axis")
	    .data(d3.range(3))
	  .enter().append("g")
	    .attr("class", "axis")
	    .attr("transform", function(d) { return "rotate(" + degrees(angle(d)) + ")"; });

	   svg.on("click",click).on("mouseover",hover);
    });
}

function degrees(radians) {
  return radians / Math.PI * 180 - 90;
}

// getter and setter method
chart.width = function(value) {
	if (!arguments.length) return width; //if no args, getter
	width = value;                       // else setter!
	return chart;  // return the function.
	// this allows us to chain calls!
};

chart.height = function(value) {
	if (!arguments.length) return height;
	height = value;
	return chart;
};


chart.innerRadius = function(value) {
	if (!arguments.length) return innerRadius; //if no args, getter
	innerRadius = value;                       // else setter!
	return chart;  // return the function.
	// this allows us to chain calls!
};

chart.outerRadius = function(value) {
	if (!arguments.length) return outerRadius;
	outerRadius = value;
	return chart;
};

chart.click = function(value) {
	if (!arguments.length) return click;
	click = value;
	return chart;
};

chart.hover = function(value) {
	if (!arguments.length) return hover;
	hover = value;
	return chart;
};


  return chart;
}

