do ($ = jQuery, ko = window.ko, fc = window.fannect) ->
   
   class fc.GreekViewModel
      constructor: (groups) ->
         @email = ko.observable()
         @selected_group = ko.observable(name: "<span class='none-selected'>Fraternity / Sorority</span>")
         @show_selector = ko.observable(false)
         @selected_index = -1
         groups[i].selected = ko.observable(false) for g, i in groups
         @groups = ko.observableArray(groups)
         @group_slider_index = ko.observable(1)
         @points_slider_index = ko.observable(0)

         @group_slider_index.subscribe (value) ->
            switch value
               when 0 then fc.changeToFraternity()
               when 1 then fc.changeToBoth()
               when 2 then fc.changeToSorority()
               
         @points_slider_index.subscribe (value) ->
            switch value
               when 0 then fc.setChartValue("overall")
               when 1 then fc.setChartValue("passion")
               when 2 then fc.setChartValue("dedication")
               when 3 then fc.setChartValue("knowledge")

      toggleSelector: () =>
         @show_selector(not @show_selector())

      selectGroup: (group) =>
         prev = @selected_index
         @selected_index = @groups.indexOf(group)
         @groups()[@selected_index].selected(true)
         @groups()[prev].selected(false) unless prev == -1
         @selected_group(group)
         @show_selector(false)

      submit: () =>
         if @email()?.length > 1 and @selected_group()._id
            $.ajax(
               url: "/"
               type: "POST"
               data: { group_id: @selected_group()._id, email: @email() }
            ).done (data, textStatus) ->
               console.log data
               console.log textStatus