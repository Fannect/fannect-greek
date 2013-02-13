do ($ = jQuery, d3 = window.d3, fc = window.fannect) ->
   ko.bindingHandlers.slideUpDown = 
      update: (element, valueAccessor, allBindingAccessor, viewModel, bindingContext) ->
         valueUnwrapped = ko.utils.unwrapObservable valueAccessor()
         allBindings = allBindingAccessor()
         duration = allBindings.duration or 400
         if valueUnwrapped
            $(element).slideDown duration
         else
            $(element).slideUp duration