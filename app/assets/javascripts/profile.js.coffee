//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min
//= require jquery.kladr.min
//= require 'jquery-ui-1.10.4.custom'
//= require 'jquery.selectBox.js'
//= require 'morris.js'
//= require 'raphael-min.js'
//= require 'jquery.maskedinput.min'
//= require 'jquery.validationEngine.js'
//= require 'jquery.validationEngine-en.js'

# KLADR credentials
kladrToken = '5322ef24dba5c7d326000045'
kladrKey = '60d44104d6e5192dcdc610c10ff4b2100ece9604'

# Chosen place id
activePlaceId = 0

# Modal container
$modalContainer = $('.modal-container')

# Empty detailed service element
emptyDetailedService = 'Здесь будет показана информация о выбранной Вами услуге'



$(document).ready ->   

# Ajax'ing registration      
  $('body').on 'click', '#reg-step-one-submit', ->
    $("#js-container").addClass('loading')
    $.ajax
      url: '/users'
      type: 'POST'
      dataType: 'html'
      data: $('#reg-step-one-form').serialize()
      success: (data) ->
        $('.reg-step-1').remove()
        $('#reg-step-one-info').removeClass('active')
        $('#reg-step-two-info').addClass('active')
        $('.reg-head').append(data)

        $("#reg-step-two-form").validationEngine()

        $('#input-place-city').kladr({
          token: kladrToken,
          key: kladrKey,
          type: $.kladr.type.city,
          select: (obj) ->
            $('#input-place-address').kladr('parentId', obj.id)
        })

        $('#input-place-address').kladr({
          token: kladrToken,
          key: kladrKey,
          type: $.kladr.type.street,
          parentType: $.kladr.type.city
        })
        $("#js-container").removeClass('loading')
      error: (data) ->
        $('.error-container').empty()
        $('.error-container').append(data.responseText)
        $("#js-container").removeClass('loading')
    
  $('body').on 'click', '#reg-step-two-submit', ->
    $("#js-container").addClass('loading')
    $.ajax
      url: '/places/reg_create'
      type: 'POST'
      dataType: 'html'
      data: $('#reg-step-two-form').serialize()
      success: (data) ->
        $('.reg-step-2').remove()
        $('#reg-step-two-info').removeClass('active')
        $('#reg-step-three-info').addClass('active')
        $('.reg-head').append(data)

        $("#reg-step-three-form").validationEngine()
        $("#js-container").removeClass('loading')
      error: (data) ->
        $('.error-container').empty()
        $('.error-container').append(data.responseText)
        $("#js-container").removeClass('loading')

  $('body').on 'click', '#reg-step-three-submit', ->
    $("#js-container").addClass('loading')
    $.ajax
      url: '/services/reg_create'
      type: 'POST'
      dataType: 'html'
      data: $('#reg-step-three-form').serialize()
      success: (data) ->
        $('.reg-step-3').remove()
        $('#reg-step-three-info').removeClass('active')
        $('#reg-step-four-info').addClass('active')
        $('.reg-head').append(data)
        $("#reg-step-four-form").validationEngine()
        commissionCalc()
        $("#js-container").removeClass('loading')
      error: (data) ->
        $('.error-container').empty()
        $('.error-container').append(data.responseText)
        $("#js-container").removeClass('loading')

  $('body').on 'click', '#reg-step-four-submit', ->
    $('#wip').html('Оплата будет доступна в ближайшее время')

# Diasbling on-click action
  $('body').on 'click', '.click-off', ->
    false

# Masking for phone input
  $(".js__phone").mask("+7 (999) 999-99-99")

# Show/Hide password
  $('input#show-pass[type="checkbox"]').change ->
    if this.checked
      $('input#input-password[type="password"]').attr('type', 'text')
    else
      $('input#input-password[type="text"]').attr('type', 'password')

# Tooltips
  $('.click_tooltips').focusin ->
    $(this).siblings('.tooltips').stop().fadeIn(200)

  $(".click_tooltips").focusout ->
    $(this).siblings('.tooltips').stop().fadeOut(200)

# Custom select
# TODO: Implement plugin  

# Validation
  $("#reg-step-one-form").validationEngine()
  
# Activating KLADR for the 1st step
  $('#input-city').kladr({
    token: kladrToken,
    key: kladrKey,
    type: $.kladr.type.city
  })

# Add place event
  $('#dashboard-add-place').on 'click', ->
    $("#js-container").addClass('loading')
    $.ajax
      url: '/places/new'
      type: 'GET'
      success: (data) ->
        $modalContainer.empty()
        $modalContainer.html(data)
        $modalContainer.find('.modal').modal('show')

        $('#input-place-city').kladr({
          token: kladrToken,
          key: kladrKey,
          type: $.kladr.type.city,
          select: (obj) ->
            $('#input-place-address').kladr('parentId', obj.id)
        })

        $('#input-place-address').kladr({
          token: kladrToken,
          key: kladrKey,
          type: $.kladr.type.street,
          parentType: $.kladr.type.city
        })
        $("#js-container").removeClass('loading')

# Add serivce event
  $('#dashboard-add-service').on 'click', ->
    $("#js-container").addClass('loading')
    $.ajax
      url: '/services/new'
      type: 'GET'
      success: (data) ->
        $modalContainer.empty()
        $modalContainer.html(data)
        $modalContainer.find('.modal').modal('show')
        $("#js-container").removeClass('loading')

# Create place event
  $('body').on 'click', '#submit-create-place', ->
    $("#js-container").addClass('loading')
    $.ajax
      url: '/places'
      type: 'POST'
      data: $('#new_place').serialize()
      success: (data) ->
        $modalContainer.find('.modal').modal('hide')
        $('#no-place').remove()
        $('#place-accordion').append(data)
        $("#js-container").removeClass('loading')
      error: (data) ->
        $('.error-container').empty()
        $('.error-container').append(data.responseText)
        $("#js-container").removeClass('loading')

# Create service event
  $('body').on 'click', '#submit-create-service', ->
    $('#new_service').find('#service-place-id').val(activePlaceId)
    $("#js-container").addClass('loading')
    $.ajax
      url: '/services'
      type: 'POST'
      data: $('#new_service').serialize()
      success: (data) ->
        $modalContainer.find('.modal').modal('hide')
        $('#no-service').remove()
        $('#service-accordion').append(data)
        $("#js-container").removeClass('loading')
      error: (data) ->
        $('.error-container').empty()
        $('.error-container').append(data.responseText)
        $("#js-container").removeClass('loading')

# Place accordion click 
  $('#place-accordion').on 'click', '.panel-heading', ->
    if !$(this).hasClass('active-accordion-item')
      activePlaceId = $(this).data('id')
      $(this).addClass('active-accordion-item')
      $('#place-accordion .panel-heading').not(this).siblings('.delete-link').hide();
      $(this).siblings('.delete-link').show();
      $('#place-accordion')
        .find('.panel-heading')
        .not(this)
        .removeClass('active-accordion-item')
      $('#dashboard-add-service').show()
      $("#js-container").addClass('loading')
      $.ajax
        url: '/services/' + activePlaceId + '/by_place'
        type: 'GET'
        success: (data) ->
          $('#no-service').remove()
          $('#service-accordion').html(data)
          $('#service-add').show()
          $("#js-container").removeClass('loading')
    else
      false

# Service accordion click 
  $('#service-accordion').on 'click', '.panel-heading', ->
    if !$(this).hasClass('active-accordion-item')
      $('#service-accordion .panel-heading').not(this).siblings('.delete-link').hide();
      $(this).siblings('.delete-link').show();
      $(this).addClass('active-accordion-item')
      $('#service-accordion')
        .find('.panel-heading')
        .not(this)
        .removeClass('active-accordion-item')
      id = $(this).data('id')
      $("#js-container").addClass('loading')
      $.ajax
        url: '/services/' + id
        type: 'GET'
        success: (data) ->
          $('#service-detailed').html(data)
          commissionCalc()
          $("#js-container").removeClass('loading')
    else
      false

# Delete place event
  $('body').on 'click', '.place-delete', ->
    if confirm 'Действительно удалить?'
      id = $(this).data('id')
      $("#js-container").addClass('loading')
      $.ajax
        url: '/places/' + id
        dataType: 'json'
        type: 'DELETE'
        success: (data) ->
          $('#container-' + id).slideUp()
          $('#service-accordion').empty();
          $('#service-accordion').append('<p id="no-service">Выберите объект</p>');
          
          $('#dashboard-add-service').hide()

          $('.menu_other').html('Выберите услугу')
          $('.edit_services_sum').html(emptyDetailedService)
          $('.payment_box').remove()
          $("#js-container").removeClass('loading')
# Delete service event
  $('body').on 'click', '.service-delete', ->
    if confirm 'Действительно удалить?'
      id = $(this).data('id')
      $("#js-container").addClass('loading')
      $.ajax
        url: '/services/' + id
        dataType: 'json'
        type: 'DELETE'
        success: (data) ->
          $('#service-container-' + id).slideUp()
          $('.menu_other').html('Выберите услугу')
          $('.edit_services_sum').html(emptyDetailedService)
          $('.payment_box').remove()
          $("#js-container").removeClass('loading')

# Edit place event
  $('body').on 'click', '.place-edit', ->
    id = $(this).data('id')
    $("#js-container").addClass('loading')
    $.ajax
      url: '/places/' + id + '/edit'
      type: 'GET'
      success: (data) ->
        $modalContainer.empty()
        $modalContainer.html(data)
        $modalContainer.find('.modal').modal('show')
        $("#js-container").removeClass('loading')
        
# Edit service event
  $('body').on 'click', '.service-edit', ->
    id = $(this).data('id')
    $("#js-container").addClass('loading')
    $.ajax
      url: '/services/' + id + '/edit'
      type: 'GET'
      success: (data) ->
        $modalContainer.empty()
        $modalContainer.html(data)
        $modalContainer.find('.modal').modal('show')
        $("#js-container").removeClass('loading')
        
# Update place event
  $('body').on 'click', '#submit-update-place', ->
    id = $(this).data('id')
    $("#js-container").addClass('loading')
    $.ajax
      url: '/places/' + id
      type: 'PUT'
      data: $('.edit_place').serialize()
      success: (data) ->
        $place = $('#place-' + id)
        $form = $('.edit_place')
        $('#container-' + id).find('.place-title').html($form.find('#input-place-title').val())
        $place.find('.place-city').html('Город: ' + $form.find('#input-place-city').val())
        $place.find('.place-type').html('Тип: ' + $form.find('#place_place_type').val())
        $place.find('.place-address').html('Адрес: ' + $form.find('#input-place-address').val() + ', ' + $form.find('#input-place-building').val())
        $place.find('.place-apartment').html('Квартира: ' + $form.find('#input-place-apartment').val())
        $modalContainer.find('.modal').modal('hide')
        $("#js-container").removeClass('loading')
      error: (data) ->
        $('.error-container').empty()
        $('.error-container').append(data.responseText)
        $("#js-container").removeClass('loading')

# Update service event
  $('body').on 'click', '#submit-update-service', ->
    id = $(this).data('id')
    $("#js-container").addClass('loading')
    $.ajax
      url: '/services/' + id
      type: 'PUT'
      data: $('.edit_service').serialize()
      success: (data) ->
        $service = $('#service-detailed')
        $form = $('.edit_service')
        $service.find('.service-type').html($form.find('#service_service_type').val())
        $service.find('.vendor').html($form.find('#service_vendor').val())
        $service.find('.user-account').html($form.find('#input-service-user-account').val())
        $('#service-container-' + id).find('.service-title').html($form.find('#input-service-title').val())
        $modalContainer.find('.modal').modal('hide')
        $("#js-container").removeClass('loading')
      error: (data) ->
        $('.error-container').empty()
        $('.error-container').append(data.responseText)
        $("#js-container").removeClass('loading')

# Commission calculation
# TODO: Refactor to the bone
  commissionCalc = () ->
    $(".pay-amount-one").keyup ->
      if $(".pay-amount-two").val() is ""
        amountTwo = 0
      else
        amountTwo = $(".pay-amount-two").val()
      amountOne = $(".pay-amount-one").val()
      if document.getElementById("i15").checked
        percent = $("#pay-commission-yandex").val()
      else if document.getElementById("i14").checked
        percent = $("#pay-commission-web-money").val()
      else
        percent = $("#pay-commission").val()
      amount = parseFloat(amountOne + "." + amountTwo)
      commission = Math.round(amount * percent) / 100
      $("#commission").html " " + commission + " руб."
      total = commission + amount
      $("#total").html " " + total + " руб."

    $(".pay-amount-two").keyup ->
      if $(".pay-amount-two").val() is ""
        amountTwo = 0
      else
        amountTwo = $(".pay-amount-two").val()
      amountOne = $(".pay-amount-one").val()
      if document.getElementById("i15").checked
        percent = $("#pay-commission-yandex").val()
      else if document.getElementById("i14").checked
        percent = $("#pay-commission-web-money").val()
      else
        percent = $("#pay-commission").val()
      amount = parseFloat(amountOne + "." + amountTwo)
      commission = Math.round(amount * percent) / 100
      $("#commission").html " " + commission + " руб."
      total = commission + amount
      $("#total").html " " + total + " руб."

    $("input:radio[name=\"pay[payment_type]\"]").change ->
      if $(".pay-amount-two").val() is ""
        amountTwo = 0
      else
        amountTwo = $(".pay-amount-two").val()
      amountOne = $(".pay-amount-one").val()
      if $(this).attr("id") is "i15"
        percent = $("#pay-commission-yandex").val()
      else if $(this).attr("id") is "i14"
        percent = $("#pay-commission-web-money").val()
      else
        percent = $("#pay-commission").val()
      amount = parseFloat(amountOne + "." + amountTwo)
      commission = Math.round(amount * percent) / 100
      $("#commission").html " " + commission + " руб."
      total = commission + amount
      $("#total").html " " + total + " руб."

  # Long Polling for widgets
  updateWidgets = ->
    $.getScript "/widgets.js"
    setTimeout updateWidgets, 30000
    return
  $ ->
    setTimeout updateWidgets, 30000  if document.getElementById("widget-container")?
    return

# Tabs in transactions
# TODO: Move to bootstrap tabs

  $('.table_analitic:not(.table_analitic:eq(0))').hide()
  $('.obj_click:first').addClass('active2')

  $('.obj_click').on 'click', ->
    $('.obj_click').removeClass('active2')
    $('.table_analitic').stop().hide()
    index = $(this).addClass('active2').index()
    $('.table_analitic').eq(index).stop().fadeIn()

  $('#transaction-place-accordion').on 'click', '.panel', ->
    if !$(this).hasClass('active-accordion-item')
      activePlaceId = $(this).data('id')
      $(this).addClass('active-accordion-item')
      $('#transaction-place-accordion')
        .find('.panel')
        .not(this)
        .removeClass('active-accordion-item')
      $('#dashboard-add-service').show()

      $.ajax
        url: '/transactions/' + activePlaceId + '/table_show'
        type: 'get'
        success: (data) ->
          $('#table-analytic').empty()
          $('#table-analytic').append(data)
    else
      false
