var AJAXLoad = function(element) {
  element.find("a").click(function(event) {
    event.preventDefault()
    $("#yield").load($(this).attr("href"))
  })
}

$(document).ready(function() {
  //AJAXLoad( $("#global-header") )
})