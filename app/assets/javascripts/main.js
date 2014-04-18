//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min

$(document).ready(function() {
    
   function function_zoom() {
 
 setTimeout(function(){$(".green").addClass('red').removeClass(function_zoom);  
  }, 300);
};
function_zoom(); 

 

 
 
	$( ".accordion_main_ob" ).accordion({
	 heightStyle: "content"	
		
	});
 
  
  	$( ".accordion_main_ob2" ).accordion({
      heightStyle: "content",	
     collapsible: true,
     active: false
	
	});
 
 
 
 
  
var current_tutorial = 0;
$(".next_tutorial").click(function () {
    $(".tutorial").stop().fadeOut();
    current_tutorial++;
    if (current_tutorial > $(".tutorial").size() - 1) {
        current_tutorial = 0
    }
    $(".tutorial").eq(current_tutorial).stop().fadeIn()
})
 
 
 $(".close_tutorial").click(function () {
 	 $('.black_over').find('.container').animate({'top':'-9999px'},1500);
     $('.black_over').stop().fadeOut();
})






  $(".start_tutorial").click(function () {
  $('.black_over').stop().fadeIn();
  $('.black_over').find('.container').animate({top:'0'},500)
})
 
  $(".close_ent").click(function () {
  $('#myModal_ent').remove()
 
});




  $('.table_analitic:not(.table_analitic:eq(0))').hide()
      $('.obj_click:first').addClass('active2');
      
      
      $('.obj_click').click (function ()
      {
        
      $('.obj_click').removeClass('active2');
      $('.table_analitic').stop().hide();
      index = $(this).addClass('active2').index();
      $('.table_analitic').eq(index).stop().fadeIn();
      });




















});