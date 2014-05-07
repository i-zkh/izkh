//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min
//= require jquery.kladr.min
//= require 'jquery-ui-1.10.4.custom'
//= require 'select2.js'
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
    $.ajax
      url: '/users'
      type: 'POST'
      beforeSend: ->
        $("#js-container").addClass('loading')
      dataType: 'html'
      data: $('#reg-step-one-form').serialize()
      success: (data) ->
        $('.reg-step-1').remove()
        $('#reg-step-one-info').removeClass('active')
        $('#reg-step-two-info').addClass('active')
        $('.reg-head').append(data)
        $("select").select2()

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

      error: (error, qwe, er) ->
        console.log(er)
        $("#js-container").removeClass('loading')
    
  $('body').on 'click', '#reg-step-two-submit', ->
    $.ajax
      url: '/places/reg_create'
      type: 'POST'
      beforeSend: ->
        $("#js-container").addClass('loading')
      dataType: 'html'
      data: $('#reg-step-two-form').serialize()
      success: (data) ->
        $('.reg-step-2').remove()
        $('#reg-step-two-info').removeClass('active')
        $('#reg-step-three-info').addClass('active')
        $('.reg-head').append(data)

        $("select").selectBox()
        $("#reg-step-three-form").validationEngine()
        $("#js-container").removeClass('loading')
      error: (error, qwe, er) ->
        console.log(er)
        $("#js-container").removeClass('loading')

  $('body').on 'click', '#reg-step-three-submit', ->
    $.ajax
      url: '/services/reg_create'
      type: 'POST'
      dataType: 'html'
      beforeSend: ->
        $("#js-container").addClass('loading')
      data: $('#reg-step-three-form').serialize()
      success: (data) ->
        $('.reg-step-3').remove()
        $('#reg-step-three-info').removeClass('active')
        $('#reg-step-four-info').addClass('active')
        $('.reg-head').append(data)
        $("#reg-step-four-form").validationEngine()
        commissionCalc()
        $("#js-container").removeClass('loading')
      error: (error) ->
        console.log(error)
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


# Validation
  if $('#reg-step-one-form').attr('id')
    $("#reg-step-one-form").validationEngine()
  
# Activating KLADR for the 1st step
  $('#input-city').kladr({
    token: kladrToken,
    key: kladrKey,
    type: $.kladr.type.city
  })

# Add place event
  $('#dashboard-add-place').on 'click', ->
    $.ajax
      url: '/places/new'
      type: 'GET'
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        $modalContainer.empty()
        $modalContainer.html(data)
        $modalContainer.find('.modal').modal('show')
        $("select").select2()

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
    $.ajax
      url: '/services/new'
      type: 'GET'
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        $modalContainer.empty()
        $modalContainer.html(data)
        $modalContainer.find('.modal').modal('show')
        $("select").select2()
        $("#js-container").removeClass('loading')

# Create place event
  $('body').on 'click', '#submit-create-place', ->
    $.ajax
      url: '/places'
      type: 'POST'
      beforeSend: ->
        $("#js-container").addClass('loading')
      data: $('#new_place').serialize()
      success: (data) ->
        $modalContainer.find('.modal').modal('hide')
        $('#no-place').remove()
        $('#place-accordion').append(data)
        $("#js-container").removeClass('loading')

# Create service event
  $('body').on 'click', '#submit-create-service', ->
    $('#new_service').find('#service-place-id').val(activePlaceId)
    $.ajax
      url: '/services'
      type: 'POST'
      beforeSend: ->
        $("#js-container").addClass('loading')
      data: $('#new_service').serialize()
      success: (data) ->
        $modalContainer.find('.modal').modal('hide')
        $('#no-service').remove()
        $('#service-accordion').append(data)
        $("#js-container").removeClass('loading')

# Place accordion click 
  $('#place-accordion').on 'click', '.panel-heading', ->
    if !$(this).hasClass('active-accordion-item')
      activePlaceId = $(this).data('id')
      $('.panel-heading').show()
      $(this).hide()
      $('#place-accordion .panel-heading').not(this).siblings('.delete-link').hide();
      $(this).siblings('.delete-link').show();
      $('#place-accordion')
        .find('.panel-heading')
        .not(this)
        .removeClass('active-accordion-item')
      $('#dashboard-add-service').show()
      $.ajax
        url: '/services/' + activePlaceId + '/by_place'
        type: 'GET'
        beforeSend: ->
          $("#js-container").addClass('loading')
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
      $.ajax
        url: '/services/' + id
        type: 'GET'
        beforeSend: ->
          $("#js-container").addClass('loading')
        success: (data) ->
          $('#service-detailed').html(data)
          commissionCalc()
          $("#js-container").removeClass('loading')
    else
      false

# Delete place event
  $('body').on 'click', '.place-delete', ->
    id = $(this).data('id')
    $.ajax
      url: '/places/' + id
      dataType: 'json'
      beforeSend: ->
        $("#js-container").addClass('loading')
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
    id = $(this).data('id')
    $.ajax
      url: '/services/' + id
      dataType: 'json'
      beforeSend: ->
        $("#js-container").addClass('loading')
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
    $.ajax
      url: '/places/' + id + '/edit'
      beforeSend: ->
        $("#js-container").addClass('loading')
      type: 'GET'
      success: (data) ->
        $modalContainer.empty()
        $modalContainer.html(data)
        $("select").selectBox()
        $modalContainer.find('.modal').modal('show')
        $("select").select2()
        $("#js-container").removeClass('loading')
        
# Edit service event
  $('body').on 'click', '.service-edit', ->
    id = $(this).data('id')
    $.ajax
      url: '/services/' + id + '/edit'
      type: 'GET'
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        $modalContainer.empty()
        $modalContainer.html(data)
        $("select").selectBox()
        $modalContainer.find('.modal').modal('show')
        $("select").select2()
        $("#js-container").removeClass('loading')
        
# Update place event
  $('body').on 'click', '#submit-update-place', ->
    id = $(this).data('id')
    $.ajax
      url: '/places/' + id
      type: 'PUT'
      beforeSend: ->
        $("#js-container").addClass('loading')
      data: $('.edit_place').serialize()
      dataType: 'json'
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

# Update service event
  $('body').on 'click', '#submit-update-service', ->
    id = $(this).data('id')
    $.ajax
      url: '/services/' + id
      type: 'PUT'
      beforeSend: ->
        $("#js-container").addClass('loading')
      dataType: 'json'
      success: (data) ->
        $service = $('#service-detailed')
        $form = $('.edit_service')
        $service.find('.service-type').html($form.find('#service_service_type_id').find('option[selected]').text())
        $service.find('.vendor').html($form.find('#service_vendor_id').find('option[selected]').text())
        $service.find('.user-account').html($form.find('#input-service-user-account').val())
        $('#service-container-' + id).find('.service-title').html($form.find('#input-service-title').val())
        $('.menu_other').html($form.find('#input-service-title').val())
        $modalContainer.find('.modal').modal('hide')
        $("#js-container").removeClass('loading')

  # Send options to select box
  $('body').on 'change', '#service_service_type_id', ->
    $.ajax
      url: '/by_service_type'
      type: 'GET'
      dataType: 'html'
      data: {service_type_id: $("#service_service_type_id").val()}
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        $('#service_vendor_id').find("option").remove()
        $('#service_vendor_id').append(data)
        $("#js-container").removeClass('loading')
      error: (error) ->
        console.log(error)
        $("#js-container").removeClass('loading')

# Commission calculation
# TODO: Refactor to the bone
  commissionCalc = () ->
    $(".pay-amount-one").keyup ->
      if $(".pay-amount-one").val() is ""
        amountOne = 0
      else
        amountOne = $(".pay-amount-one").val()
      if document.getElementById("i15").checked
        percent = $("#pay-commission-yandex").val()
      else if document.getElementById("i14").checked
        percent = $("#pay-commission-web-money").val()
      else
        percent = $("#pay-commission").val()
      amount = parseFloat(amountOne)
      commission = Math.round(amount * percent) / 100
      $("#commission").html " " + commission + " руб."
      total = commission + amount
      $("#total").html " " + total + " руб."

    $("input:radio[name=\"pay[payment_type]\"]").change ->
      if $(".pay-amount-one").val() is ""
        amountOne = 0
      else
        amountOne = $(".pay-amount-one").val()
      if $(this).attr("id") is "i15"
        percent = $("#pay-commission-yandex").val()
      else if $(this).attr("id") is "i14"
        percent = $("#pay-commission-web-money").val()
      else
        percent = $("#pay-commission").val()
      amount = parseFloat(amountOne)
      commission = Math.round(amount * percent) / 100
      $("#commission").html " " + commission + " руб."
      total = commission + amount
      $("#total").html " " + total + " руб."


  map = new ymaps.Map("map", {center: [53.25, 50.26], zoom: 12, controls: []})


  # Long Polling for widgets
  updateWidgets = ->
    $.getScript "/widgets.js"
    setTimeout updateWidgets, 30000
    return
  $ ->
    setTimeout updateWidgets, 30000  if document.getElementById("widget-container")?
    return
