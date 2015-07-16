class @LookUpView
  constructor: (selector) ->
    @element = $(selector)
    @text_field = @element.find('.look-up-search-text')
    @result_div = @element.find('.look-up-result')
    @result_id = @element.find('.look-up-result-id')
  
  init: ->
    that = @
    @text_field.keyup ->
      that.set_search_data()

  set_search_data: () ->
    that = @

    search_data = @text_field.val()
    url = "/people/live_search?q=#{search_data}"

    $.ajax
      url: url
      dateType: "html"
      success: (data, textStatus, jqXHR) ->
        that.result_div.html(data)
        that.set_result()

  set_result: () ->
    that = @
    $(".live-choice").each( ->
      $(this).click( ->
        res_id = $(this).attr("id");
        res_id = res_id.substring(12);

        that.result_id.val(res_id)
        that.result_div.html('')
      )  
    )