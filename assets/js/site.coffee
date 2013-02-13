#= require "lib/jquery-1.8.2.js"
#= require "lib/knockout.js"
#= require "lib/binding-handlers.coffee"
#= require "chart.coffee"
#= require "viewModel.coffee"

do ($ = jQuery, d3 = window.d3, fc = window.fannect) ->
   $(document).ready () ->
      vm = new fc.GreekViewModel(fc.groups)
      ko.applyBindings(vm)