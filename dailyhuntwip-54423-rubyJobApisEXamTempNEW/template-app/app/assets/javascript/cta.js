$(function($) {
  display_square_img();
  display_text_alignment();
  display_rectangle_img();
  display_button();
});  
function display_text_alignment(){
  if($("#bx_block_categories_cta_is_text_cta").is(":checked")){
    $("#bx_block_categories_cta_text_alignment_field").show();
  }else{
    $("#bx_block_categories_cta_text_alignment_field").hide();
  }
}

function display_square_img(){
  if($("#bx_block_categories_cta_is_image_cta").is(":checked") && $("#bx_block_categories_cta_is_square_cta").is(":checked")){
    $("#bx_block_categories_cta_square_background_image_field").show();
  }else{
    $("#bx_block_categories_cta_square_background_image_field").hide();
  }
}

function display_rectangle_img(){
  if($("#bx_block_categories_cta_is_image_cta").is(":checked") && $("#bx_block_categories_cta_is_long_rectangle_cta").is(":checked")){
    $("#bx_block_categories_cta_long_background_image_field").show();
  }else{
    $("#bx_block_categories_cta_long_background_image_field").hide();
  }
}

function display_button(){
  if($("#bx_block_categories_cta_has_button").is(":checked")){
    $("#bx_block_categories_cta_button_text_field").show();
    $("#bx_block_categories_cta_redirect_url_field").show();
    $("#bx_block_categories_cta_button_alignment_field").show();

  }else{
    $("#bx_block_categories_cta_button_text_field").hide();
    $("#bx_block_categories_cta_redirect_url_field").hide();
    $("#bx_block_categories_cta_button_alignment_field").hide();
  }
}

$(document).on('click', '#bx_block_categories_cta_is_text_cta, #bx_block_categories_cta_is_image_cta, #bx_block_categories_cta_is_square_cta, #bx_block_categories_cta_is_long_rectangle_cta, #bx_block_categories_cta_has_button ',function () {
  display_square_img();
  display_rectangle_img();
  display_text_alignment();
  display_button();
});

$(document).on('click', '.bx_block_categories_cta_row .icon-pencil, .icon.new_collection_link ' ,function () {
  setTimeout(function(){
    display_square_img();
    display_rectangle_img();
    display_text_alignment();
    display_button();
  }, 500);
});

$(window).load(function () {
  setTimeout(function(){
    display_text_alignment();
    display_square_img();
    display_rectangle_img();
    display_button();
  }, 200);
});