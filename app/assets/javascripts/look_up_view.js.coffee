class @LookUpView
  constructor: (selector, path, parent) ->
    @element = $(selector)
    @path = path
    @text_field = @element.find('.look-up-search-text')
    @result_div = @element.find('.look-up-result')
    @result_id = @element.find('.look-up-result-id')
    @result_name = @element.find('.look-up-result-name')
    @enable_button = @element.find('.look-up-button')
    @parent = parent

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
    search_data = @text_field.val()
    if (@result_name)
      @result_name.val(search_data)

    if (search_data.length < 3)
      @result_div.html('')
      return

    parent_id = ''
    if (@parent)
      parent_id = @parent.val()

    url = "/#{@path}/live_search?q=#{search_data}&p=#{parent_id}"
    @get_ajax(url)

  get_ajax: (url) ->
    that = @
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