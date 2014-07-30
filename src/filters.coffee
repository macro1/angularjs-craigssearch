angular.module("search").filter "delta", ->
  (delta) ->
    seconds = Math.floor(delta / 1000)
    minutes = Math.floor(seconds / 60)
    hours = Math.floor(minutes / 60)
    days = Math.floor(hours / 24)
    return days + "d " + (hours - days * 24) + "h"  if days > 0
    return hours + "h " + (minutes - hours * 60) + "m"  if hours > 0
    return minutes + "m " + (seconds - minutes * 60) + "s"  if minutes > 0
    seconds + "s"
