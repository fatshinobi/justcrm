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


$(function() {
  init_main();
});

$(document).on('page:load', function() {
  init_main();
});

$(document).on('nested:fieldAdded', function(event) {
  lookUpElem = event.field.find('.lookup-div');
  id_elem = event.field.find('.look-up-result-id');
  var id = id_elem.attr('id').match(/\d+/)[0];
  lookUpElem.attr('id', id);

  company_view = new LookUpView('#' + id, 'companies');
  company_view.init();

  if (typeof window.nested_semaphore == 'undefined') {
    window.nested_semaphore = new Semaphore();
  }
  
  window.nested_semaphore.add(company_view);  
  window.nested_semaphore.init();
});

function init_main() {
  var data_controller = $('body').attr('data_controller');
  var person_view, company_view;
  var semaphore;

  if (data_controller == 'opportunities') {
    company_view = new LookUpView('#opportunity_company_look_up', 'companies');    
    person_view = new LookUpView('#opportunity_person_look_up', 'people', company_view.result_id);
    semaphore = set_semaphore(company_view, person_view);
  }

  if (data_controller == 'appointments') {
    company_view = new LookUpView('#appointment_company_look_up', 'companies');    
    person_view = new LookUpView('#appointment_person_look_up', 'people', company_view.result_id);
    semaphore = set_semaphore(company_view, person_view);    
  }

  if (typeof person_view != 'undefined') {
    person_view.init();
  }

  if (typeof company_view != 'undefined') {
    company_view.init();
  }

  if (typeof semaphore != 'undefined') {
    semaphore.init();
  }

};

function set_semaphore(view1, view2) {
  semaphore = new Semaphore();
  semaphore.add(view1);
  semaphore.add(view2);

  return semaphore;
};
