do ($ = jQuery, d3 = window.d3, fc = window.fannect) ->
   
   $(document).ready () ->
      height = 350
      width = 1150
      padding = 4
      bottom_padding = 105

      frat = []
      sorority = []

      for group in fc.groups 
         if ("fraternity" in group.tags)
            group.style = "fraternity"
            frat.push(group)
         else 
            group.style = "sorority"
            sorority.push(group)

      both = frat.concat(sorority)
      chart = null

      getXFunc = (count) ->
         return d3.scale.linear().domain([0, 1]).range([0, width / (count)])

      normalizeName = (name) -> name.replace(/\s/g, "").toLowerCase()
      
      setupChart = () ->
         chart = d3.select(".chart-wrap").append("svg")
            .attr("class", "chart")
            .attr("width", width)
            .attr("height", height)

         fc.setChartValue("overall")

      fc.setChartValue = (prop) ->
         el.data = el.points[prop] for el in both

         max = 18
         (max = d.points.overall if d.points.overall > max) for d in both
         max = max * 1.05
         
         y = d3.scale.linear().domain([0, max]).rangeRound([0, height - bottom_padding])
         x = getXFunc(both.length)
         
         # create bars
         chart.selectAll("rect.bar")
               .data(both, (d) -> d._id)
            .enter().append("rect")
               .attr("x", (d, i) -> i * width / both.length + padding / 2)
               .attr("y", (d) -> height)
               .attr("width", (width / both.length) - padding)
               .attr("height", 0)
               .attr("class", (d) -> d.style + " bar")
            
         # update bars
         chart.selectAll("rect.bar")
            .transition()
               .delay(100)
               .duration(750)
               .ease("quad-out")
               .attr("y", (d) -> height - y(d.data) - .5 - bottom_padding)
               .attr("height", (d) -> y(d.data) + bottom_padding)

         # create number
         chart.selectAll("text.number")
               .data(both, (d) -> d._id)
            .enter().append("text")
               .attr("x", (d, i) -> x(i) + (width / both.length))
               .attr("y", (d, i) -> height)
               .attr("dx", (d, i) -> -(width / both.length / 2))
               .attr("dy", "1.3em")
               .attr("text-anchor", "middle")
               .attr("class", "number")
               .text((d) -> 0)
            
         # update number
         chart.selectAll("text.number")
            .transition()
               .delay(100)
               .duration(750)
               .ease("quad-out")
               .attr("y", (d, i) -> height - y(d.data) - .5 - bottom_padding)
               .tween("text", (d) ->
                  i = d3.interpolate(this.textContent, d.data)
                  return (t) -> this.textContent = parseInt(i(t)))

         # create names
         chart.selectAll("text.name")
               .data(both, (d) -> "name_" + d._id)
            .enter().append("text")
               .attr("transform", (d, i) -> "translate(#{x(i) + 4 + (width / both.length / 2)},#{height + 100})rotate(-90)")
               .attr("class", "name")
               .text((d) -> d.name)
            .transition()
               .delay(100)
               .duration(750)
               .ease("quad-out")
               .attr("dx", 110)

      fc.changeToFraternity = () ->
         x = getXFunc(frat.length)
         w =  width / frat.length - padding

         chart.selectAll("rect.bar")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> i * width / frat.length + padding / 2)
               .attr("width", w)

         chart.selectAll("text.number")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) + (width / frat.length))
               .attr("dx", (d, i) -> -(width / frat.length / 2))

         chart.selectAll("text.name")
               .data(both, (d) -> "name_" + d._id)
            .transition()
               .duration(1000)
               .attr("transform", (d, i) -> "translate(#{i * width / frat.length + padding / 2 + w / 2 + 4},#{height + 100})rotate(-90)")
               
      fc.changeToSorority = () ->
         x = getXFunc(sorority.length)
         w = width / sorority.length

         chart.selectAll("rect.bar")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> i * w + padding / 2 - (w * frat.length))
               .attr("width", w - padding)

         chart.selectAll("text.number")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) + (width / sorority.length) - (w * frat.length))
               .attr("dx", (d, i) -> -(width / sorority.length / 2))

         chart.selectAll("text.name")
               .data(both, (d) -> "name_" + d._id)
            .transition()
               .duration(1000)
               .attr("transform", (d, i) -> "translate(#{i * w + padding / 2 - (w * frat.length) + w / 2 + 4},#{height + 100})rotate(-90)")
               

      fc.changeToBoth = () ->
         x = getXFunc(both.length)

         chart.selectAll("rect.bar")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> i * width / both.length + padding / 2)
               .attr("width", width / both.length - padding)

         chart.selectAll("text.number")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) + (width / both.length))
               .attr("dx", (d, i) -> -(width / both.length / 2))

         chart.selectAll("text.name")
               .data(both, (d) -> "name_" + d._id)
            .transition()
               .duration(1000)
               # .attr("transform", "translate(222,222)scale(23)")
               # .attr("transform", (d, i) -> "translate(#{x(i) + 4 + (width / both.length / 2)},#{height + 100})")
               .attr("transform", (d, i) -> "translate(#{x(i) + 4 + (width / both.length / 2)},#{height + 100})rotate(-90)")
            # .transition()
            #    .duration(1000)
            #    .attr("y", (d, i) -> x(i) + 4 + (width / both.length / 2))
               # .attr("dx", (d, i) -> -(width / both.length / 2))


      _createGradient = (id, start, stop) =>
         gradient = chart.append("svg:linearGradient")
            .attr("id", id)
            .attr("x1", "0%")
            .attr("y1", "0%")
            .attr("x2", "0%")
            .attr("y2", "100%")
            .attr("spreadMethod", "pad");
          
         gradient.append("svg:stop")
            .attr("offset", "0%")
            .attr("stop-color", start)
            .attr("stop-opacity", 1);
          
         gradient.append("svg:stop")
            .attr("offset", "100%")
            .attr("stop-color", stop)
            .attr("stop-opacity", 1);

      setupChart()      
      _createGradient("fraternity-gradient", fc.config.fraternity.start_color, fc.config.fraternity.stop_color)
      _createGradient("sorority-gradient", fc.config.sorority.start_color, fc.config.sorority.stop_color)
