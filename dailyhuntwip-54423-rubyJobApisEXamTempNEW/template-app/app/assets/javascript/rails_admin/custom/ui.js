//= require cta.js

$(function($) {
  $("a[href='/admin_users/sign_out'] .label.label-danger").text("Logout");
  $(".dashboard_root_link").hide();
  $(".rails_admin .content .page-header h1").hide();

  $("#bx_block_admin_admin_user_template_field").hide();
  if( $("#bx_block_admin_admin_user_role_id :selected").text() != "Partner" ){
    $("#bx_block_admin_admin_user_partner_attributes_field").hide();
  }

  $("#bx_block_admin_admin_user_role_id").on("change", function(){
    if($("#bx_block_admin_admin_user_role_id :selected").text() == "Partner"){
      $("#bx_block_admin_admin_user_partner_attributes_field").show();
      $('#bx_block_admin_admin_user_password').removeAttr('required');
      $('#bx_block_admin_admin_user_password_confirmation').removeAttr('required');
      $('#bx_block_admin_admin_user_password_field').hide();
      $('#bx_block_admin_admin_user_password_confirmation_field').hide();
    }else{
      $("#bx_block_admin_admin_user_partner_attributes_field").hide();  
      $('#bx_block_admin_admin_user_password_field').show();
      $('#bx_block_admin_admin_user_password_confirmation_field').show();
    }
  });
});

$(window).load(function () {
  setTimeout(function(){
    $('label[for="schema_methods_contentable_attributes"]').parent().remove();
  }, 200);
});

$(document).on('click', '.icon.export_collection_link',function () {
  setTimeout(function(){
    $('label[for="schema_methods_contentable_attributes"]').parent().remove();
  }, 200);
});
