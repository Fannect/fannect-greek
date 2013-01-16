do ($ = jQuery, d3 = window.d3) ->
   
   $(document).ready () ->

      height = 250
      width = 600

      id = 0
      v = 70

      next = () ->
         return {
            id: ++id
            value1: v = ~~Math.max(10, Math.min(90, v + 10 * (Math.random() - .5)))
            value2: v = ~~Math.max(10, Math.min(90, v + 10 * (Math.random() - .5)))
         }



      frat = d3.range(10).map(next)
      sorority = d3.range(10).map(next)
      both = frat.concat sorority
      chart = null

      getXFunc = (count) ->
         return d3.scale.linear().domain([0, 1]).range([0, width / (count)])
      
      setupChart = () ->
         chart = d3.select("body").append("svg")
            .attr("class", "chart")
            .attr("width", width)
            .attr("height", height)

         setChartValue("value1")

         chart.append("line")
            .attr("x1", 0)
            .attr("x2", width)
            .attr("y1", height - .5)
            .attr("y2", height - .5)
            .style("stroke", "#000")

      setChartValue = (prop) ->
         y = d3.scale.linear().domain([0, 90]).rangeRound([0, height])
         x = getXFunc(both.length)

         el.data = el[prop] for el in both
         
         # create bars
         chart.selectAll("rect")
               .data(both, (d) -> d.id)
            .enter().append("rect")
               .attr("x", (d, i) -> x(i) - .5)
               .attr("y", (d) -> height)
               .attr("width", width / both.length)
               .attr("height", 0)
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
               .data(both, (d) -> d.id)
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
               .data(both, (d) -> d.id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) )
               .attr("width", width / frat.length)

         chart.selectAll("text")
               .data(both, (d) -> d.id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) + (width / frat.length))
               .attr("dx", (d, i) -> -(width / frat.length / 2))
            
      changeToSorority = () ->
         x = getXFunc(sorority.length)
         w = width / sorority.length

         chart.selectAll("rect")
               .data(both, (d) -> d.id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) - (w * frat.length) )
               .attr("width", w)

         chart.selectAll("text")
               .data(both, (d) -> d.id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) + (width / sorority.length) - (w * frat.length))
               .attr("dx", (d, i) -> -(width / sorority.length / 2))

      changeToBoth = () ->
         x = getXFunc(both.length)

         chart.selectAll("rect")
               .data(both, (d) -> d.id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i))
               .attr("width", width / both.length)

         chart.selectAll("text")
               .data(both, (d) -> d.id)
            .transition()
               .duration(1000)
               .attr("x", (d, i) -> x(i) + (width / both.length))
               .attr("dx", (d, i) -> -(width / both.length / 2))

      setupChart()

      $("#frat").click () -> changeToFraternity()
      $("#sorority").click () -> changeToSorority()
      $("#both").click () -> changeToBoth()
      $("#value1").click () -> setChartValue "value1"
      $("#value2").click () -> setChartValue "value2"
