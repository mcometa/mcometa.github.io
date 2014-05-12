#= require vendor/lib/jquery
#= require vendor/fancybox/jquery.fancybox

"use strict"

self = undefined
App =
  init: ->
    self = this
    self.bindEvents()
    self.setupFancybox()
    return

  bindEvents: ->
    item = document.querySelectorAll(".portfolio-item")
    [].forEach.call item, (el) ->
      el.addEventListener "mouseover", (->
        @querySelector(".details").style.bottom = "0"
        return
      ), false
      el.addEventListener "mouseout", (->
        @querySelector(".details").style.bottom = "-500px"
        return
      ), false
      return

    return

  setupFancybox: ->
    $("[rel='fancybox']").fancybox()

App.init()