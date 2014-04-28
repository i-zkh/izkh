//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min
//= require 'jquery.selectBox'
//= require 'jquery-ui-1.10.4.custom'
//= require 'morris'
//= require 'jquery.maskedinput.min'
$(document).ready(function() {

    function function_zoom() {

        setTimeout(function() {
            $(".green").addClass('red').removeClass(function_zoom);
        }, 300);
    };
    function_zoom();


    $(".accordion_main_ob").accordion({
        heightStyle: "content"

});





    $('#input-phone').focusout(function() {
        $(".tutorial").stop().fadeOut()
    });


    $('#input-phone').focusin(function() {
        $('.tutorial').stop().fadeIn()
    });

    $("#none_tut").click(function() {
        $(".tutorial").remove();

    });

    $(".click_tooltips").focusin(function() {
        $(this).siblings('.tooltips').stop().fadeIn(200);
    });
    $(".click_tooltips").focusout(function() {
        $(this).siblings('.tooltips').stop().fadeOut(200);
    });

    $(".tutorial", this).find('.close_tutorial').click(function() {
        $('.tutorial').remove();
    });

    $(".tutorial:eq(0)").css({
        'display': 'block'
    });

    var current_tutorial = 0;
    $(".next_tutorial").click(function() {
        $(".tutorial").stop().fadeOut();
        current_tutorial++;
        if (current_tutorial > $(".tutorial").size() - 1) {
            current_tutorial = 0
        }
        $(".tutorial").eq(current_tutorial).stop().fadeIn()
    });

    $('.close_ent').click(function() {
        $('#myModal_ent').modal('hide');
    });

    $(".close_tutorial").click(function() {
        $('.black_over').find('.container').animate({
            'top': '-9999px'
        }, 1500);
        $('.black_over').stop().fadeOut();
    });

    $(".start_tutorial").click(function() {
        $('.black_over').stop().fadeIn();
        $('.black_over').find('.container').animate({
            top: '0'
        }, 500)
    });

    $(".accordion_main_ob2").accordion({
        heightStyle: "content",
        collapsible: true,
        active: false

    });

    $("select").selectBox();

    $(".metrics_box_add").on("click", function() {
        $('.metrics_box_type').stop().fadeIn()
        $(this).stop().hide()
    });

    $(".metrics__more").on("click", function() {
        $('.history-metrics, .dell-and-close').stop().fadeIn()

    });

    $(".metrics__close").on("click", function() {
        $('.history-metrics, .dell-and-close').stop().hide()

    });

    $(".metrics__del").on("click", function() {
        if (confirm("Вы уверены что хотите удалить счетчик?")) {
            $('.metrics_box_history').stop().hide()
        } else {

        }
    });
    $(".js__phone").mask("+7 (999) 999-99-99");


    $('input#show-pass[type="checkbox"]').change(function() {

        if (this.checked) {
            $('input#input-password[type="password"]').attr('type', 'text');
        } else {
            $('input#input-password[type="text"]').attr('type', 'password');
        }

    });









    $('.table_analitic:not(.table_analitic:eq(0))').hide();
    $('.obj_click:first').addClass('active2');


    $('.obj_click').click(function() {

        $('.obj_click').removeClass('active2');
        $('.table_analitic').stop().hide();
        index = $(this).addClass('active2').index();
        $('.table_analitic').eq(index).stop().fadeIn();
    });


    // new Morris.Line({
    //     // ID of the element in which to draw the chart.
    //     element: 'myfirstchart',
    //     // Chart data records -- each entry in this array corresponds to a point on
    //     // the chart.
    //     data: [{
    //             ye: '2012 Q0',
    //             value: 100,
    //             value2: 900,
    //             value3: 700,
    //             value4: 200
    //         }, {
    //             ye: '2012 Q1',
    //             value: 300,
    //             value2: 1300,
    //             value3: 800,
    //             value4: 400
    //         }, {
    //             ye: '2012 Q2',
    //             value: 600,
    //             value2: 1400,
    //             value3: 900,
    //             value4: 900
    //         }, {
    //             ye: '2012 Q3',
    //             value: 900,
    //             value2: 1500,
    //             value3: 1000,
    //             value4: 1500
    //         }

    //     ],
    //     xLabels: "",
    //     lineColors: ['#000', '#ed1653', 'green', '#006ba5'],
    //     // The name of the data record attribute that contains x-values.
    //     xkey: ['ye'],
    //     // A list of names of data record attributes that contain y-values.
    //     ykeys: ['value', 'value2', 'value3', 'value4'],
    //     // Labels for the ykeys -- will be displayed when you hover over the
    //     // chart.
    //     labels: ['квартплата', 'газ', 'свет', 'другое']
    // });





});
