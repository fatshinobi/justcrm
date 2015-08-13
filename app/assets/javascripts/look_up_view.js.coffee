class @LookUpView
  constructor: (selector, path) ->
    @element = $(selector)
    @path = path
    @text_field = @element.find('.look-up-search-text')
    @result_div = @element.find('.look-up-result')
    @result_id = @element.find('.look-up-result-id')
    @enable_button = @element.find('.look-up-button')

  init: ->
    that = @
    @text_field.keyup ->
      that.set_search_data()
    @enable_button.click ->
      that.set_enabled()
    @text_field.focusout ->
      that.empty_choice()

  set_enabled: () ->
    @text_field.removeAttr('disabled')
    @text_field.val('')
    @text_field.focus()   

  empty_choice: () ->
    that = @
    that.text_field.attr('disabled', 'disabled')
    that.result_id.val('')

  set_search_data: () ->
    that = @

    search_data = @text_field.val()
    #url = "/people/live_search?q=#{search_data}"
    url = "/#{@path}/live_search?q=#{search_data}"

    $.ajax
      url: url
      dateType: "html"
      success: (data, textStatus, jqXHR) ->
        that.result_div.html(data)
        that.set_result()

  set_result: () ->
    that = @
    @result_div.find(".live-choice").each( ->
      $(this).click( ->
        res_id = $(this).attr("id");
        res_id = res_id.substring(12);

        that.result_id.val(res_id)
        that.text_field.val($(this).text())
        that.text_field.attr('disabled', 'disabled')
        that.result_div.html('')
      )  
    )