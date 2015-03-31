// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
//= require select2
//= require jquery.form-validator

var attachTypeAhead = function(){
  $('.select2').each(function(i, e){
    var select = $(e)
    options = { minimumInputLength: 3 }
    if (select.hasClass('ajax')) {
      options.ajax = {
        url: select.data('source'),
        dataType: 'json',
        data: function(term, page) { return { q: term } },
        results: function(data, page) { return { results: data } }
      }
      options.dropdownCssClass = "bigdrop"
      options.createSearchChoice = function(term, data) {
        if ( $(data).filter( function() {
          return this.text.localeCompare(term)===0;
        }).length===0) {
           return {id:term, text:term};
        }
      }
      options.initSelection = function (element, callback) {
        var data = [];
        callback({ id: element.val(), text: element.val() });
      }
    }
    select.select2(options)
  });
};

$(document).ready(function() {
  $.validate({modules: 'security', form: "#new_user, #edit_user"});
});