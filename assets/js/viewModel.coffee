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
         @points_menu_index = ko.observable(0)
         @show_validator = ko.observable(false)
         @validator_text = ko.observable("")
         @show_success = ko.observable()
         @is_submitting = ko.observable()

         @group_slider_index.subscribe (value) ->
            switch value
               when 0 then fc.changeToFraternity()
               when 1 then fc.changeToBoth()
               when 2 then fc.changeToSorority()
               
         @points_menu_index.subscribe (value) ->
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
         return if @is_submitting()
         if @email()?.length > 1 and @selected_group()._id
            @is_submitting(true)
            @show_validator(false)
            @show_success(false)
            $.ajax(
               url: "/"
               type: "POST"
               data: { group_id: @selected_group()._id, email: @email() }
            ).done (data, textStatus) =>
               @is_submitting(false)
               console.log data
               if data?.message?.indexOf("User does not have a profile for team") > -1
                  @show_validator(true)
                  @validator_text("You don't seem to be a fan of the #{window.fannect.config.team_name} yet!")
               else if data?.message?.indexOf("Invalid: email") > -1
                  @show_validator(true)
                  @validator_text("No account tied to #{@email()}!")
               else if data?.message?.indexOf("User is already a part of group") > -1
                  @show_validator(true)
                  @validator_text("You are already part of this house!")
               else if data?.status == "success"
                  @show_success(true)
                  @email("")
                  setTimeout (() => @show_success(false)), 3000
               else 
                  @show_validator(true)
                  @validator_text("Something unexpected happened... try again later!")
         else
            @show_validator(true)
            @validator_text("Please enter an email and select a fraternity or sorority!")