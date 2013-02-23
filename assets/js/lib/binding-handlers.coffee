do ($ = jQuery, d3 = window.d3, fc = window.fannect) ->
   ko.bindingHandlers.slideUpDown = 
      update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
         valueUnwrapped = ko.utils.unwrapObservable valueAccessor()
         allBindings = allBindingsAccessor()
         duration = allBindings.duration or 400
         $el = $(element)
         $el.stop() if allBindings.stopPrevious
         if valueUnwrapped
            $el.slideDown duration
         else
            $el.slideUp duration

   ko.bindingHandlers.clickOff = 
      init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
         value = valueAccessor()
         $("body").click (event) ->  
            if not $(event.target).closest(element).length
               value(false)

   ko.bindingHandlers.slider = 
      init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
         value = valueAccessor()
         count = allBindingsAccessor().count
         $el = $(element)
         $el.find(".slider-cover").css("left", ko.utils.unwrapObservable(value) * ($el.width() / count) + "px")

         $children = $el.find(".slider-item").click () ->
            value($children.index(this))

         $el.find(".slider-left-button").click () ->
            newIndex = value() - 1
            newIndex = 0 if newIndex < 0
            value(newIndex)
         $el.find(".slider-right-button").click () ->
            newIndex = value() + 1
            newIndex = count - 1 if newIndex >= count
            value(newIndex)

      update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
         index = ko.utils.unwrapObservable valueAccessor()
         $el = $(element)
         count = allBindingsAccessor().count
         $el.find(".slider-cover").animate({left: index * ($el.width() / count) })

   ko.bindingHandlers.menu = 
      init: (element, valueAccessor, allBindingsAccessor, viewModel) ->
         value = valueAccessor()

         $children = $(element).find("a").click () ->
            value($children.index(this))
            $children.removeClass("active")
            $(this).addClass("active")
         