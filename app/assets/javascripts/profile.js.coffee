//= require jquery_ujs
//= require turbolinks
//= require jquery.kladr.min
//= require dashboard
//= require chekbox
//= require kladr
//= require 'jquery.selectbox-0.2'
//= require main
//= require 'jquery-ui-1.10.4.custom'
//= require 'jquery.maskedinput.min'



$(document).ready ->   
    
  
$('#reg-step-one-submit').on "click", ->
  $.ajax
    url: '#{users_path}'
    type: 'POST'
    dataType: 'json'
    data: $('#reg-step-one-form').serialize()
    complete: (data) ->
      $('.reg-step-1').hide()
      $('#input-place-city').attr('value', $('#input-city').val())
      $('#reg-step-one-info').removeClass('active')
      $('#reg-step-two-info').addClass('active')
      $('.reg-step-2').show()
  

$('#reg-step-two-submit').on "click", ->
  $.ajax
    url: '/places'
    type: 'POST'
    dataType: 'json'
    data: $('#reg-step-two-form').serialize()
    complete: (data) ->
      $('.reg-step-2').hide()
      $('.reg-step-3').show()
      $('#reg-step-two-info').removeClass('active')
      $('#reg-step-three-info').addClass('active')

$('#reg-step-three-submit').on "click", ->
  $.ajax
    url: '/services'
    type: 'POST'
    dataType: 'json'
    data: $('#reg-step-three-form').serialize()
    complete: (data) ->
      $('.reg-step-3').hide()
      $('.reg-step-4').show()
      $('#reg-step-three-info').removeClass('active')
      $('#reg-step-four-info').addClass('active')

$('#reg-step-four-submit').on "click", ->
  $('#wip').html('Оплата будет доступна в ближайшее время')




 