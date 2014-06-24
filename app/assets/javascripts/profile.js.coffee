//= require jquery_ujs
//= require bootstrap.min
//= require jquery.kladr.min
//= require 'jquery-ui-1.10.4.custom'
//= require 'select2.js'
//= require 'morris.js'
//= require 'raphael-min.js'
//= require 'jquery.maskedinput.min'
//= require 'jquery.validationEngine.js'
//= require 'jquery.scrolling-parallax.js'
//= require 'jquery.validationEngine-en.js'
//= require 'jquery.fastLiveFilter.js'
# KLADR credentials
kladrToken = '5322ef24dba5c7d326000045'
kladrKey = '60d44104d6e5192dcdc610c10ff4b2100ece9604'

# Chosen place id
activePlaceId = 0

# Modal container
$modalContainer = $('.modal-container')

# Empty detailed service element
emptyDetailedService = 'Здесь будет показана информация о выбранной Вами услуге'

# ymaps.ready ->
#   map = new ymaps.Map("map", {center: [53.22, 50.12], zoom: 12, controls: []})
  # ymaps.geocode("Самара ул. Владимирская, 41А",
  #   results: 1
  # ).then (res) ->
  #   # Выбираем первый результат геокодирования.
  #   firstGeoObject = res.geoObjects.get(0)
  #   # Добавляем первый найденный геообъект на карту.
  #   map.geoObjects.add firstGeoObject

$(document).ready ->

  ymaps.ready ->
    address = ["Самара ул. Владимирская, 41А","Самара Заводское шоссе, 6","Самара ул. Ленинградская, 100","Самара Крутые ключи, 24","Самара ул. 22 Партсъезда, 1","Самара ул. Матросова, 27/55","Самара Заводское шоссе, 48","Самара ул. Земеца, 20","Самара ул. Советской Армии, 200","Самара ул. Олимпийская, 68А","Самара ул. Гагарина, 14","Самара ул. Победы, 75","Самара ул. Победы, 95","Самара ул. Галактионовская, 32","Самара ул. Спортивная, 3","Самара ул. Егорова, 10А","Самара ул. Революционная, 75","Самара ул. Первомайская, 26","Самара Московское шоссе, литера А","Самара пр.Металлургов, 77","Самара пр.Юных Пионеров, 146","Самара ул. Аминева, 29","Самара ул. Ново-Садовая, 323","Самара ул. Белорусская, 131","Самара пос. Мехзавод, 2-й квартал, 52","Самара п. Мехзавод, 2-й квартал, 49А","Самара ул. Ставропольская, 86","Самара ул. Черемшанская, 131","Самара пр. Металлургов, 8","Самара пр. Карла Маркса, 510Е","Самара пр. Карла Маркса, 510Е","Самара ул. Олимпийская, 68А","Самара Красная Глинка, 2-й квартал, 24","Самара ул. Гагарина, 157","Самара пр. Ленина, 5","Самара ул. Белорусская, 131","Самара ул. Егорова, 10А","Самара ул. Зеленая, 19","Самара ул. Аэродромная, 117","Самара  Зубчаниновское шоссе, 151","Самара  пр. Карла Маркса, 510B","Самара  пр. Кирова проспект, 273","Самара  проезд Мальцева, 9, рынок Бакалея, Литер Х","Самара  Молодежный пер, 22","Самара  ул. 22 Партсъезда, 56г","Самара  ул. Советской Армии, 17","Самара  ул. Стара Загора, 220А","Самара  ул. Ташкентская, 93","Самара  ул .Ташкентская, 99","Самара  ул. Юбилейная, 9","Самара  Московское шоссе, 28","Самара  ул. Физкультурная, 29","Самара  пр. Металлургов, 78","Самара  ул. Свободы, 73","Самара  ул. Егорова, 5А","Самара  ул. Карбышева, 61","Самара  ул. Воеводина, 16","Самара  ул. Победы, 168","Самара  ул. Измайловский переулок, 2","Самара  ул. Ногина, 6","Самара  ул. Тополей, 3","Самара  6 просека, 141","Самара  пос. Красная Глинка, 5 квартал 4А","Самара  ул. Полевая, 65","Самара  ул. Красноармейская, 62А","Самара  ул. Губанова, 15","Самара  ул Московское шоссе, 320/Ташкенская","Самара  ул. 22 Партсъезда, 34","Самара  ул. Советской Армии, 132","Самара  ул. Победы, 125","Самара  ул. Ставропольская, 177Б","Самара  бульвар Фенютина, 62","Самара  ул. Фадеева, 67","Самара  пр. Кирова, 226А","Самара  ул. Булкина, 78","Самара  ул.Партизанская, 184","Самара  ул.Стара-Загоры, 124А","Самара  Костромский пер., 10","Самара  ул. Ново-Вокзальная, 12","Самара  ул. Ново-Садовая, 387","Самара  ул. Революционная, 163А","Самара  ул. Владимирская, 35А","Самара  ул. Аминева, 1","Самара  ул. Арцыбушевская, 34А","Самара  ул. Ставропольская, 51","Самара  ул. Ново-Вокзальная, 1 (торговый павильон № Л 32)","Самара  пос. Управленческий, ул. Сергея Лазо, 15 Б","Самара  ул. Минская, 34","Самара  пр. Ленина, 12А","Самара  ул. Авроры, 181","Самара  ул. Ново-Садовая, 192/2","Самара  ул. Ставропольская, 86","Самара  ул. Партизанская, 174 А, магазин \"Семерочка\", секция № 33,li  2 этаж.","Самара  ул. Куйбышева, 100/ул.Некрасовская,21","Самара  Ново-молодежный пер., д. 19 (116 км)","Самара  ул. Стара-Загора, 59, строение 1","Самара  пр. Карла Маркса,li  179","Самара  ул. Минская, 25","Самара  ул. Гагарина, 120 к1","Самара  ул. Ново-Садовая, 36","Самара  ул. Победы, 131","Самара  ул Советская, 42","Самара  ул А.Толстого, 18","Самара  ул Пугачевский Тракт, 13","Самара  ул Галактионовская, 130","Самара  ул Аэродромная, 72","Самара  ул Промышленности, 285","Самара  ул Ново-Вокзальная, 195","Самара  ул. Дыбенко, 120","Самара  проспект Ленина, д.1","Самара  ул. Георгия Димитрова, 44","Самара  ул. Георгия Димитрова, 117","Самара  ул. Ставропольская, 74","Самара  ул. Ставропольская, 202","Самара  ул. Стара-Загора, 108","Самара  ул. Чернореченская, 47","Самара  ул. Чернореченская, 49","Самара  ул. Физкультурная, 33","Самара  ул. Калинина, 14","Самара  ул. Георгия Димитрова, 27","Самара  ул. Стара-Загора, 85"]
    map = new ymaps.Map("map", {center: [53.22, 50.12], zoom: 12, controls: []})
    if document.getElementById("js_search_input")
      address.forEach (entry) ->
        ymaps.geocode(entry,
          results: 1
        ).then (res) ->
          # Выбираем первый результат геокодирования.
          firstGeoObject = res.geoObjects.get(0)
          # Добавляем первый найденный геообъект на карту.
          map.geoObjects.add firstGeoObject

# Ajax'ing registration 

  if $('#pay')[0]
    $('#pay').find('select').select2()

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

        $("select").select2()
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

#  Mask for "Царьград"
  $.mask.definitions['п'] = "[ГЦМгцм]"
  $.mask.definitions['в'] = "[ГЦСИгцси]"
  $.mask.definitions['т'] = "[ОДГодг]" 

  $('body').on 'change', '#vendor_id', ->
    $(".js__user_account").unmask();
    $('.info-account').empty()
    if $('#vendor_id').val() == "134"
      $(".js__user_account").mask("пвт-9999")
      $('.info-account').empty()
      $('.info-account').append('<p>Возможные префиксы: ГСО, ЦГД, ЦЦГ, МИГ</p><p>Пример: ГСО-1234</p>')

  $('body').on 'change', '#service_vendor_id', ->
    $(".js__user_account").unmask();
    $('.info-account').empty()
    if $('#service_vendor_id').val() == "134"
      $('.info-account').empty()
      $('.info-account').append('<p>Возможные префиксы: ГСО, ЦГД, ЦЦГ, МИГ</p><p>Пример: ГСО-1234</p>')
      $(".js__user_account").mask("пвт-9999")

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
        $('#place-accordion').prepend(data)
        $("#js-container").removeClass('loading')
        $("#place-index").find("h4").maxlength maxChars: 10

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
        $('#service-accordion').prepend(data)
        $("#js-container").removeClass('loading')
        $("#service-index").find("h4").maxlength maxChars: 20

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
          $("#service-index").find("h4").maxlength maxChars: 10
    else
      false

  # Analitics place accordion click
  $('#transaction-place-accordion').on 'click', '.panel-heading', ->
    if !$(this).hasClass('active-accordion-item')
      $('#place-accordion .panel-heading').not(this).siblings('.delete-link').hide();
      $(this).siblings('.delete-link').show();
      $(this).addClass('active-accordion-item')
      $('#transaction-place-accordion')
        .find('.panel-heading')
        .not(this)
        .removeClass('active-accordion-item')
      if $('.show-table').hasClass('active')
        $.ajax
          url: '/table_show'
          type: 'GET'
          data: { id: $(this).data('id')}
          beforeSend: ->
            $("#js-container").addClass('loading')
          success: (data) -> 
            $('.analytics-block').html(data)
            $("#js-container").removeClass('loading')
      else
        $.ajax
          url: '/graph_show'
          type: 'GET'
          dataType: 'json'
          data: { id: $(this).data('id')}
          beforeSend: ->
            $("#js-container").addClass('loading')
          success: (data) -> 
            $('.analytics-block').html("<div id='graph'></div>")
            console.log data
            if data.ykeys.length
              Morris.Line({
                element: 'graph',
                xkey: data.xkey,
                ykeys: data.ykeys,
                labels: data.labels,
                data: data.data
              });
            else
              $('#graph').html('<p>У объекта нет подключенных услуг</p>')
            $("#js-container").removeClass('loading')
    else
      false

  # Analitics place accordion click
  $('#transaction-place-accordion').on 'click', '.panel-heading', ->
    if !$(this).hasClass('active-accordion-item')
      $('#place-accordion .panel-heading').not(this).siblings('.delete-link').hide();
      $(this).siblings('.delete-link').show();
      $(this).addClass('active-accordion-item')
      $('#transaction-place-accordion')
        .find('.panel-heading')
        .not(this)
        .removeClass('active-accordion-item')
      if $('.show-table').hasClass('active')
        $.ajax
          url: '/table_show'
          type: 'GET'
          data: { id: $(this).data('id')}
          beforeSend: ->
            $("#js-container").addClass('loading')
          success: (data) -> 
            $('.analytics-block').html(data)
            $("#js-container").removeClass('loading')
      else
        $.ajax
          url: '/graph_show'
          type: 'GET'
          dataType: 'json'
          data: { id: $(this).data('id')}
          beforeSend: ->
            $("#js-container").addClass('loading')
          success: (data) -> 
            $('.analytics-block').html("<div id='graph'></div>")
            console.log data
            Morris.Line({
              element: 'graph',
              xkey: data.xkey,
              ykeys: data.ykeys,
              labels: data.labels,
              data: data.data
            });
            $("#js-container").removeClass('loading')
    else
      false

# Show graph click
  $('#analytics').on 'click', '.show-graph', ->
    unless $(this).hasClass('active') 
      $('#transaction-place-accordion').find('.panel-heading').removeClass('active-accordion-item')
      $('.analytics-block').html("<div class='text'>Выберите объект</div>")
      $('.show-graph').addClass('active')
      $('.show-table').removeClass('active')

# Show table click
  $('#analytics').on 'click', '.show-table', ->
    unless $(this).hasClass('active')
      $('#transaction-place-accordion').find('.panel-heading').removeClass('active-accordion-item')
      $(this).addClass('active')
      $('.show-graph').removeClass('active')
      $('.analytics-block').html("<div class='text'>Выберите объект</div>")

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
          $(".title__span").maxlength maxChars: 10
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
        $("select").select2()
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
        $("select").select2()
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
        $place.find('.place-city').html($form.find('#input-place-city').val())
        $place.find('.place-type').html($form.find('#place_place_type').val())
        $place.find('.place-address').html($form.find('#input-place-address').val() + ', ' + $form.find('#input-place-building').val())
        $place.find('.place-apartment').html($form.find('#input-place-apartment').val())
        $modalContainer.find('.modal').modal('hide')
        $("#js-container").removeClass('loading')
        $("#place-index").find("h4").maxlength maxChars: 10
      error: (e) ->
        console.log e
        $("#js-container").removeClass('loading')

# Update service event
  $('body').on 'click', '#submit-update-service', ->
    id = $(this).data('id')
    $.ajax
      url: '/services/' + id
      type: 'PUT'
      data: $('.edit_service').serialize()
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
        $("#service-index").find("h4").maxlength maxChars: 20
      error: (e) ->
        console.log e
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

  $('body').on 'change', '#service_type_id', ->
    $.ajax
      url: '/by_service_type_with_pay'
      type: 'GET'
      dataType: 'html'
      data: {service_type_id: $("#service_type_id").val()}
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        $('#vendor_id').find("option").remove()
        $('#vendor_id').append(data)
        $("#js-container").removeClass('loading')
      error: (error) ->
        console.log(error)
        $("#js-container").removeClass('loading')

  $('body').on 'change', '#service_vendor_id', ->
    $.ajax
      url: '/tariff_template'
      type: 'GET'
      dataType: 'html'
      data: {vendor_id: $("#service_vendor_id").val()}
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        $('#service_tariff_template_id').find("option").remove()
        $('#service_tariff_template_id').append(data)
        $("#js-container").removeClass('loading')
      error: (error) ->
        console.log(error)
        $("#js-container").removeClass('loading')

# Show meters form
  $('body').on 'click', '.show-meters', ->
    serviceId = $('#service-accordion').find('.active-accordion-item').data('id')
    $.ajax
      url: '/meters'
      type: 'GET'
      data: {service_id: serviceId}
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        $('#service-index').hide()
        $('#service-container').hide()
        $('#place-index').hide()
        $('#place-index').after(data)
        $("#js-container").removeClass('loading')
      error: (error) ->
        $("#js-container").removeClass('loading')

  $('body').on 'click', '.back-to-service', ->
    $('#service-index').show()
    $('#service-container').show()
    $('#place-index').show()
    $('#meter-index').remove() 

  $('body').on 'click', '.show-meter-form', ->
    $.ajax
      url: '/meters/new'
      type: 'GET'
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        $('.meter-form').append(data)
        $('.show-meter-form').hide()
        $('.no-meter').hide()
        $('select').select2()
        $("#js-container").removeClass('loading')
      error: (error) ->
        $("#js-container").removeClass('loading')

  $('body').on 'click', '#submit-create-meter', ->
    serviceId = $('#service-accordion').find('.active-accordion-item').data('id')
    $('#meter_service_id').val(serviceId)
    $.ajax
      url: 'meters'
      type: 'POST'
      data: $('#new_meter').serialize()
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        $('.meters').append(data)
        $('.meter-form').empty()
        $('.show-meter-form').show()
        $('.no-meter').hide()
        $("#js-container").removeClass('loading')
      error: (error) ->
        $("#js-container").removeClass('loading')

  $('body').on 'click', '.metric-submit', ->
    meterId = $(this).data('meter-id')    
    form = $(this).closest('#new_metric')
    metric = form.find('#metric_metric').val()
    $.ajax
      url: 'metrics'
      type: 'POST'
      data: form.serialize()
      beforeSend: ->
        $("#js-container").addClass('loading')
      success: (data) ->
        form[0].reset()
        $('.last-metric[data-id=' + meterId + ']').html(metric)
        $('.no-metric').hide()
        $('#status').show()
        $('#status').fadeOut(4000)
        $(".metrics[data-id=" + meterId + "]").append(data)
        $("#js-container").removeClass('loading')
      error: (error) ->
        $("#js-container").removeClass('loading')

  $('body').on 'click', '.delete-meter', ->
    c = confirm("Действительно удалить?")
    if c
      meterId = $(this).data('id')
      $.ajax
        url: 'meters/' + meterId
        type: 'DELETE'
        beforeSend: ->
          $("#js-container").addClass('loading')
        success: (data) ->
          $('.meter[data-id=' + meterId + ']').remove()
          $("#js-container").removeClass('loading')
        error: (error) ->
          $("#js-container").removeClass('loading')

  # $('body').on 'click', '.service-container', ->
  #   serviceId = $(this).data('id')    
  #   $.ajax
  #     url: '/get_amount'
  #     type: 'GET'
  #     data: {id: serviceId}
  #     beforeSend: ->
  #       $("#js-container").addClass('loading')
  #     success: (data) ->
  #       console.log(data)
  #       $('#amount').empty()
  #       $('#amount').append(data)
  #       $("#js-container").removeClass('loading')
  #     error: (error) ->
  #       $("#js-container").removeClass('loading')

  # $('.feedback-container').on 'click', '.feedback-button', ->
  #   $.ajax
  #     url: '/user_feedbacks'
  #     type: 'POST'
  #     dataType: 'html'
  #     beforeSend: ->
  #       $("#js-container").addClass('loading')
  #     success: (data) ->
  #       alert(true)
  #       $('#feedback_topic').val('')
  #       # $('textarea').val('')
  #       # $('#feedback-error').append(data)
  #       $("#js-container").removeClass('loading')
  #     error: (error) ->
  #       console.log(error)
  #       $("#js-container").removeClass('loading')

  $('body').on 'click', '.hide-history', ->
    $('.metric-history').slideUp()

  $('body').on 'click', '.hide-history', ->
    meterId = $(this).data('id')
    $('.show-history').show()
    $('.metrics-history[data-id=' + meterId + ']').slideUp()

  $('body').on 'click', '.show-history', ->
    meterId = $(this).data('id')
    $('.metrics-history[data-id=' + meterId + ']').slideDown()
    $(this).hide()


# Commission calculation
# TODO: Refactor to the bone
  $('#pay').on "change", "#vendor_id", ->
    commissionQuickPay()

  $('#pay').on "keyup", ".pay-amount-one", ->
    commissionQuickPay()

  $('#pay').on "change", "input:radio[name=\"pay[payment_type]\"]", ->
    commissionQuickPay()

  commissionQuickPay = () =>
    if $(".pay-amount-one").val() is ""
      amountOne = 0
    else
      amountOne = $(".pay-amount-one").val()
    if  document.getElementById("i15").checked
      percent = $("#vendor_id").find("option:selected").data('commission-yandex')
    else if  document.getElementById("i14").checked
      percent = $("#vendor_id").find("option:selected").data('commission-ya-card')
    # else if  document.getElementById("i16").checked || document.getElementById("i18").checked
    #   percent = $("#vendor_id").find("option:selected").data('commission-ya-cash-in')
    else if  document.getElementById("i17").checked
      percent = $("#vendor_id").find("option:selected").data('commission-web-money')
    else
      percent = $("#vendor_id").find("option:selected").data('commission')
    amount = parseFloat(amountOne)
    commission = Math.round(amount * percent) / 100
    $("#commission").html " " + commission + " руб."
    total = commission + amount
    $("#total").html " " + total + " руб."

  commissionCalc = () ->
    $(".pay-amount-one").keyup ->
      if $(".pay-amount-one").val() is ""
        amountOne = 0
      else
        amountOne = $(".pay-amount-one").val()

      if document.getElementById("i15").checked
        percent = $("#pay-commission-yandex").val()
      else if document.getElementById("i14").checked
        percent = $("#pay-commission-ya-card").val()
      # else if document.getElementById("i16").checked|| document.getElementById("i18").checked
      #   percent = $("#pay-commission-ya-cash-in").val()
      else if document.getElementById("i17").checked
        percent = $("#pay-commission-web-money").val()
      else
        percent = $("#pay-commission").val()
      amount = parseFloat(amountOne)
      commission = Math.round(amount * percent) / 100

      $("#commission").html " " + commission + " руб."
      total = commission + amount
      $("#total").html(" " + total + " руб.")

    $("input:radio[name=\"pay[payment_type]\"]").change ->
      if $(".pay-amount-one").val() is ""
        amountOne = 0
      else
        amountOne = $(".pay-amount-one").val()

      if $(this).attr("id") is "i15"
        percent = $("#pay-commission-yandex").val()
      else if $(this).attr("id") is "i14"
        percent = $("#pay-commission-ya-card").val()
      # else if $(this).attr("id") is "i16" || $(this).attr("id") is "i18"
      #   percent = $("#pay-commission-ya-cash-in").val()
      else if $(this).attr("id") is "i17"
        percent = $("#pay-commission-web-money").val()
      else
        percent = $("#pay-commission").val()
      amount = parseFloat(amountOne)
      commission = Math.round(amount * percent) / 100
      $("#commission").html " " + commission + " руб."
      total = commission + amount
      $("#total").html(" " + total + " руб.")

  # Long Polling for widgets
  updateWidgets = ->
    $.getScript "/widgets.js"
    setTimeout updateWidgets, 30000
    return
  $ ->
    setTimeout updateWidgets, 30000  if document.getElementById("widget-container")?
    return


  $("body").removeClass('loading')
    # Tabs About
  $(".tabs__about:not(.tabs__about:eq(0))").hide()
  $("#about-header h3:first").addClass "active"
  $("#about-header h3").click ->
    $("#about-header h3").removeClass "active"
    $(".tabs__about").stop().hide()
    index = $(this).addClass("active").index()
    $(".tabs__about").eq(index).stop().fadeIn()
    return
  # создаём плагин maxlength
  jQuery.fn.maxlength = (options) ->
    
    # определяем параметры по умолчанию и прописываем указанные при обращении
    settings = jQuery.extend(
      maxChars: 10 # максимальное колличество символов
      leftChars: "character left" # текст в конце строки информера
    , options)
    
    # выполняем плагин для каждого объекта
    @each ->
      # определяем объект
      $me = $(this)
      # определяем динамическую переменную колличества оставшихся для ввода символов
      l = settings.maxChars
      # определяем события на которые нужно реагировать
      text = $me.text()
      meL = text.length
      console.log meL >= l
      $me.text text.substr(0, l) + "…"  if meL >= l
      return

  $("#service-index").find("h4").maxlength maxChars: 20
  $("#place-index").find("h4").maxlength maxChars: 10
  $(".places-block").find("h4").maxlength maxChars: 24
  $("#feedback-form").validationEngine()

  $(".tutorial", this).find(".close_tutorial").click ->
    $(".tutorial").remove()
    return

  $(".tutorial:eq(0)").css display: "block"
  current_tutorial = 0
  $(".next_tutorial").click ->
    $(".tutorial").stop().fadeOut()
    current_tutorial++
    $(".tutorial").eq(current_tutorial).stop().fadeIn()
    return

  $(".close_ent").click ->
    $("#myModal_ent").modal "hide"
    return

  $(".close_tutorial").click ->
    $(".black_over").find(".container").animate
      top: "-9999px"
    , 1500
    $(".black_over").stop().fadeOut()
    return

   $("input[type=\"checkbox\"]").change ->
    if this.checked
      $('.next_tutorial').addClass('close_tutorial_button')
    else
      $('.next_tutorial').removeClass('close_tutorial_button')

  $('#js-tutorial').on "click", ".close_tutorial_button", ->
    $.ajax
      url: '/tutorial/off'
      type: 'POST'
      success: (data) ->
        $(".tutorial").remove()
        return

  $("#js_search_input").fastLiveFilter "#search_list"
  $("#search-form").fastLiveFilter "#search_result" 