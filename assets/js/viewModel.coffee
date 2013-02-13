do ($ = jQuery, ko = window.ko, fc = window.fannect) ->
   
   class fc.GreekViewModel
      constructor: (groups) ->
         @email = ko.observable()
         @selected_group = ko.observable(name: "Fraternity / Sorority")
         @show_selector = ko.observable(false)
         @groups = ko.observableArray(groups)

      toggleSelector: () =>
         @show_selector(not @show_selector())

      selectGroup: (group) =>
         @selected_group(group)
         @show_selector(false)