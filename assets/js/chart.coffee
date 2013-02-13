do ($ = jQuery, d3 = window.d3, fc = window.fannect) ->
   
   $(document).ready () ->
      height = 400
      width = 800

      frat = []
      sorority = []
      both = fc.groups

      for group in fc.groups 
         if ("fraternity" in group.tags)
            group.style = "fraternity"
            frat.push(group)
         else 
            group.style = "sorority"
            sorority.push(group)

      chart = null

      getXFunc = (count) ->
         return d3.scale.linear().domain([0, 1]).range([0, width / (count)])
      
      setupChart = () ->
         chart = d3.select(".chart-wrap").append("svg")
            .attr("class", "chart")
            .attr("width", width)
            .attr("height", height)

         setChartValue("overall")

         chart.append("line")
            .attr("x1", 0)
            .attr("x2", width)
            .attr("y1", height - .5)
            .attr("y2", height - .5)
            .style("stroke", "#000")

      setChartValue = (prop) ->
         el.data = el.points[prop] for el in both

         max = 16
         (max = d.points.overall if d.points.overall > max) for d in both
         max = max * 1.20
         
         y = d3.scale.linear().domain([-2, max]).rangeRound([0, height])
         x = getXFunc(both.length)
         
         # create bars
         chart.selectAll("rect")
               .data(both, (d) -> d._id)
            .enter().append("rect")
               .attr("x", (d, i) -> x(i) - .5)
               .attr("y", (d) -> height)
               .attr("width", width / both.length)
               .attr("height", 0)
               .attr("class", (d) -> d.style )
            .transition()
               .delay(100)
               .duration(750)
               .ease("quad-out")
               .attr("y", (d) -> height - y(d.data) - .5)
               .attr("height", (d) -> y(d.data))

         # update bars
         chart.selectAll("rect")
            .transition()
               .delay(100)
               .duration(750)
               .ease("quad-out")
               .attr("y", (d) -> height - y(d.data) - .5)
               .attr("height", (d) -> y(d.data))

         # create text
         chart.selectAll("text")
               .data(both, (d) -> d._id)
            .enter().append("text")
               .attr("x", (d, i) -> x(i) + (width / both.length))
               .attr("y", (d, i) -> height)
               .attr("dx", (d, i) -> -(width / both.length / 2))
               .attr("dy", "1.3em")
               .attr("text-anchor", "middle")
               .text((d) -> 0)
            .transition()
               .delay(100)
               .duration(750)
               .ease("quad-out")
               .attr("y", (d, i) -> height - y(d.data) - .5)
               .tween("text", (d) ->
                  i = d3.interpolate(this.textContent, d.data)
                  return (t) -> this.textContent = parseInt(i(t)))

         # update text
         chart.selectAll("text")
             .transition()
               .delay(100)
               .duration(750)
               .ease("quad-out")
               .attr("y", (d, i) -> height - y(d.data) - .5)
               .tween("text", (d) ->
                  i = d3.interpolate(this.textContent, d.data)
                  return (t) -> this.textContent = parseInt(i(t)))


      changeToFraternity = () ->
         x = getXFunc(frat.length)

         chart.selectAll("rect")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) )
               .attr("width", width / frat.length)

         chart.selectAll("text")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) + (width / frat.length))
               .attr("dx", (d, i) -> -(width / frat.length / 2))
            
      changeToSorority = () ->
         x = getXFunc(sorority.length)
         w = width / sorority.length

         chart.selectAll("rect")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) - (w * frat.length) )
               .attr("width", w)

         chart.selectAll("text")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) + (width / sorority.length) - (w * frat.length))
               .attr("dx", (d, i) -> -(width / sorority.length / 2))

      changeToBoth = () ->
         x = getXFunc(both.length)

         chart.selectAll("rect")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i))
               .attr("width", width / both.length)

         chart.selectAll("text")
               .data(both, (d) -> d._id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) + (width / both.length))
               .attr("dx", (d, i) -> -(width / both.length / 2))

      setupChart()

      $("#frat").click () -> changeToFraternity()
      $("#sorority").click () -> changeToSorority()
      $("#both").click () -> changeToBoth()
      $("#overall-button").click () -> setChartValue "overall"
      $("#passion-button").click () -> setChartValue "passion"
      $("#dedication-button").click () -> setChartValue "dedication"
      $("#knowledge-button").click () -> setChartValue "knowledge"
