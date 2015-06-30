// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.flot.js
//= require jquery.flot.funnel.js
//= require turbolinks
//= require bootstrap-sprockets
//= require jquery_nested_form
//= require_tree .

$(document).on('nested:fieldAdded', function(event){
  var data_controller = $('body').attr('data_controller');
  var field = event.field; 
  var choiceField = field.find('.live_search_text')[0];
  var outField = field.find('.out_live_search');
  var srcBtn = field.find('.live_search_button')[0];
  var result = field.find('.live_search_results')[0];
  var resultName = field.find('.live_search_name_results')[0];

  init_search_field(choiceField);

  srcBtn.onclick = function() {
    init_search_field(choiceField);
  };

  choiceField.onkeyup = function() {
    var controller_path = "";
    if (data_controller == 'people')
      controller_path = 'companies';
    else if (data_controller == 'companies')
      controller_path = 'people';

    var formData = choiceField.value;
    resultName.value = formData;
    var url = "/" + controller_path + "/live_search?q=" + formData; // live_search action.       
    $.get(url, formData, function(html) { // perform an AJAX get
      result.innerHTML = html; // replace the "results" div with the results
      set_choice(outField, choiceField, result);
    });
  };

});

function init_search_field(choiceField) {
    choiceField.value = '';
    choiceField.disabled = false;
    choiceField.focus();
}

function set_choice(out_field, out_text, result_div) {
  $(".live-choice").each(function(i) {
    $(this).click(function() {
      var res_id = $(this).attr("id");
      res_id = res_id.substring(12);

      out_field.val(res_id);
      out_text.value = $(this).text();
      out_text.disabled = true;
      result_div.innerHTML = '';
    });
  });
}
