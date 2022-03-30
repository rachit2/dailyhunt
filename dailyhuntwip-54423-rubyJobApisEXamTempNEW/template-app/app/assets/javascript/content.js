//= require jquery
//= require chosen-jquery
const call_content_detail_api = function(data){
  $.ajax({
    type: "GET",
    url: "/bx_block_contentmanagement/contents/get_content_detail",
    data: data,
    success: function(result) {
      if(result){
        $(".contentable_id").html(result)
      }
    },
    error: function(e){
      console.log(e);
    }
  });
};

const set_bannerable = function(selected = ""){
  bannerable_type = $("#bx_block_contentmanagement_banner_bannerable_type :selected").val();
    $.ajax({
    type: "GET",
    url: `/bx_block_contentmanagement/contents/bannerable?bannerable=${bannerable_type}`,
    success: function(result) {
      if(result){
        data = result["content"]["data"];
        bannerable_id = $("#bx_block_contentmanagement_banner_bannerable_id");
        bannerable_id.empty();
        $.each(data, function(index, value) {
          var option = $("<option/>", {
            value: value["id"],
            text: value["attributes"]["name"]
          });
          bannerable_id.append(option);
        });
        if(selected != ''){
          $(`#bx_block_contentmanagement_banner_bannerable_id option[value=${selected}]`).attr('selected','selected');
        }
      }
    },
    error: function(e){
      console.log(e);
    }
  });
};

const content_form_setup = function(){
  var modal = $("#author_modal");

  // Get the button that opens the modal
  var author_modal_btn = $("#author_modal_btn");

  // Get the <span> element that closes the modal
  var span = $("#close");

  // When the user clicks on the button, open the modal
  author_modal_btn.click(function() {
    modal.show();
  });

  $("#form_error").hide();
  // When the user clicks on <span> (x), close the modal
  span.click(function() {
    modal.hide();
  });
}

const create_author = function(){
  let authenticity_token = $('[name="csrf-token"]')[0].content;
  $('#daterange_form [name="authenticity_token"]').val(authenticity_token);
  var formData = new FormData(document.querySelector("#daterange_form"));
  $(".disabled_save_btn").attr("disabled", true)
  $.ajax({
    type: "POST",
    url: $('#create_author_url').val(),
    data: formData,
    cache:false,
    contentType: false,
    processData: false,
    success: function(result) {
      // location.reload(true);
      console.log(result);
      $('#bx_block_contentmanagement_content_author_id').append($("<option selected></option>")
                    .attr("value", result.author.id)
                    .text(result.author.name));
      // $('#bx_block_contentmanagement_content_author_id  option[value=""]').prop("selected", true);
      $("#author_modal").hide();
      $("#form_error").hide();
      $(".disabled_save_btn").attr("disabled", false);
      $("#author_name, #author_bio, #author_image").val("");
    },
    error: function(e) {
      console.log(e);
      $('#form_error').html(e.responseJSON.errors).show();
      $(".disabled_save_btn").attr("disabled", false);
    }
  });
};

const category_sub_category_dropdown = function(){
  $("#bx_block_contentmanagement_content_sub_category_id").parent().hide();
  sub_category1 = $("#bx_block_contentmanagement_content_sub_category_id").html();
  $("#bx_block_contentmanagement_content_category_id").on("change", function(){
    filter_sub_category(sub_category1);
  });
  filter_sub_category(sub_category1);
};

const category_sub_category_dropdown_assessment = function(){
  $("#bx_block_contentmanagement_assessment_sub_category_id_field").hide();
  sub_category_assessment = $("#bx_block_contentmanagement_assessment_sub_category_id").html();
  $("#bx_block_contentmanagement_assessment_category_id").on("change", function(){
    filter_sub_category_assessment(sub_category_assessment);
  });
  filter_sub_category_assessment(sub_category_assessment);
};

const category_sub_category_dropdown_quiz = function(){
  $("#bx_block_contentmanagement_quiz_sub_category_id_field").hide();
  sub_category_quiz = $("#bx_block_contentmanagement_quiz_sub_category_id").html();
  $("#bx_block_contentmanagement_quiz_category_id").on("change", function(){
    filter_sub_category_quiz(sub_category_quiz);
  });
  filter_sub_category_quiz(sub_category_quiz);
};

const category_sub_category_dropdown_course = function(){
  $("#bx_block_contentmanagement_course_sub_category_id_field").hide();
  sub_category_course = $("#bx_block_contentmanagement_course_sub_category_id").html();
  $("#bx_block_contentmanagement_course_category_id").on("change", function(){
    filter_sub_category_course(sub_category_course);
  });
  filter_sub_category_course(sub_category_course);
};

const category_sub_category_dropdown_exam = function(){
  $("#bx_block_contentmanagement_exam_sub_category_id_field").hide();
  sub_category_exam = $("#bx_block_contentmanagement_exam_sub_category_id").html();
  $("#bx_block_contentmanagement_exam_category_id").on("change", function(){
    filter_sub_category_exam(sub_category_exam);
  });
  filter_sub_category_exam(sub_category_exam);
};

const content_provider_dropdown = function(){
  get_values();
  get_content_provider(category_val, sub_category_val, content_type_val);
  $("#bx_block_contentmanagement_content_category_id, #bx_block_contentmanagement_content_sub_category_id, #bx_block_contentmanagement_content_content_type_id").on("change", function(){
    get_values();
    if(category_val != '' && sub_category_val != '' && content_type_val != ''){
      get_content_provider(category_val, sub_category_val, content_type_val);
    }
  });
}

const get_values = function(){
  category_val = $("#bx_block_contentmanagement_content_category_id :selected").val(); 
  sub_category_val = $("#bx_block_contentmanagement_content_sub_category_id :selected").val(); 
  content_type_val = $("#bx_block_contentmanagement_content_content_type_id :selected").val();
}

const get_content_provider = function(category_val, sub_category_val, content_type_val){
  $.ajax({
    type: "GET",
    url: "/bx_block_contentmanagement/contents/get_content_provider",
    data: {category_id: category_val, sub_category_id: sub_category_val, content_type_id: content_type_val},
    success: function(result) {
      if(result){
        data = result["content_provider"];
        admin_user_id = $("#bx_block_contentmanagement_content_admin_user_id");
        admin_user_id.empty();
        $.each(data, function(index, value) {
          var option = $("<option/>", {
            value: value["id"],
            text: value["email"]
          });
          admin_user_id.append(option);
        });
        if(data.length > 0){
          $(".show_content_msg").css("display", "none");
        }else{
          $(".show_content_msg").css("display", "block");
        }
      }
    },
    error: function(e){
      console.log(e);
    }
  });
}

const review_status_dropdown = function(){
  $("#bx_block_contentmanagement_content_review_status").on("change", function(){
    if($("#bx_block_contentmanagement_content_review_status :selected").text() == "Rejected"){
      $("#bx_block_contentmanagement_content_feedback").prop('required',true);
    }else{
      $("#bx_block_contentmanagement_content_feedback").prop('required',false);
    }
  });
};

const category_sub_category_dropdown_for_muliple = function(){
  if(window.location.href.includes("new")){
    $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids_field").hide();
    $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids").parent().hide();
  }

  sub_category = $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids").html();
  $("#bx_block_admin_admin_user_partner_attributes_category_ids").on("change", function(){
    filter_sub_category_for_mutliple(sub_category);
  });
  filter_sub_category_for_mutliple(sub_category);
};

const filter_sub_category_for_mutliple = function(sub_category2){
  category_array = [];
  $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids").html("");
  $("#bx_block_admin_admin_user_partner_attributes_category_ids :selected").each(function(){
     category_array.push($(this).text());
  })
  if(category_array.length > 0){
    var options = '';
    $.each(category_array, function( index, value ) {
      if ($(sub_category2).filter("optgroup[label='" + value + "']").html() != ""){
        options = '<optgroup label=' + value +'>'
      }
      options += $(sub_category2).filter("optgroup[label='" + value + "']").html();
      if(options){
        $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids_field").show();
        $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids").append(options);
        $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids").parent().show();
      }
      else{
        $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids_field").hide();
        $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids").empty();
        $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids").parent().hide();
      }
    });
  }else{
    $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids_field").hide();
    $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids").empty();
    $("#bx_block_admin_admin_user_partner_attributes_sub_category_ids").parent().hide();
  }
};

const filter_sub_category = function(sub_category1){
  category1 = $("#bx_block_contentmanagement_content_category_id :selected").text();
  options1 = $(sub_category1).filter("optgroup[label='" + category1 + "']").html();
  if(options1){
    $("#bx_block_contentmanagement_content_sub_category_id").html(options1);
    $("#bx_block_contentmanagement_content_sub_category_id").parent().show();
  }
  else{
    $("#bx_block_contentmanagement_content_sub_category_id").empty();
    $("#bx_block_contentmanagement_content_sub_category_id").parent().hide();
  }
};

const filter_sub_category_assessment = function(sub_category1){
  category1 = $("#bx_block_contentmanagement_assessment_category_id :selected").text();
  options1 = $(sub_category1).filter("optgroup[label='" + category1 + "']").html();
  if(options1){
    $("#bx_block_contentmanagement_assessment_sub_category_id").html(options1);
    $("#bx_block_contentmanagement_assessment_sub_category_id_field").show();
  }
  else{
    $("#bx_block_contentmanagement_assessment_sub_category_id").empty();
    $("#bx_block_contentmanagement_assessment_sub_category_id_field").hide();
  }
};

const filter_sub_category_quiz = function(sub_category1){
  category1 = $("#bx_block_contentmanagement_quiz_category_id :selected").text();
  options1 = $(sub_category1).filter("optgroup[label='" + category1 + "']").html();
  if(options1){
    $("#bx_block_contentmanagement_quiz_sub_category_id").html(options1);
    $("#bx_block_contentmanagement_quiz_sub_category_id_field").show();
  }
  else{
    $("#bx_block_contentmanagement_quiz_sub_category_id").empty();
    $("#bx_block_contentmanagement_quiz_sub_category_id_field").hide();
  }
};

const filter_sub_category_course = function(sub_category1){
  category1 = $("#bx_block_contentmanagement_course_category_id :selected").text();
  options1 = $(sub_category1).filter("optgroup[label='" + category1 + "']").html();
  if(options1){
    $("#bx_block_contentmanagement_course_sub_category_id").html(options1);
    $("#bx_block_contentmanagement_course_sub_category_id_field").show();
  }
  else{
    $("#bx_block_contentmanagement_course_sub_category_id").empty();
    $("#bx_block_contentmanagement_course_sub_category_id_field").hide();
  }
};

const filter_sub_category_exam = function(sub_category1){
  category1 = $("#bx_block_contentmanagement_exam_category_id :selected").text();
  options1 = $(sub_category1).filter("optgroup[label='" + category1 + "']").html();
  if(options1){
    $("#bx_block_contentmanagement_exam_sub_category_id").html(options1);
    $("#bx_block_contentmanagement_exam_sub_category_id_field").show();
  }
  else{
    $("#bx_block_contentmanagement_exam_sub_category_id").empty();
    $("#bx_block_contentmanagement_exam_sub_category_id_field").hide();
  }
};


const is_blog = function(){
  return $('#blog-content-type-id').text() != "" &&
    $('#bx_block_contentmanagement_content_content_type_id option:selected').val() == $('#blog-content-type-id').text();
};

const is_video = function(){
  console.log($('#bx_block_contentmanagement_content_content_type_id option:selected').val());
  return $('#bx_block_contentmanagement_content_content_type_id option:selected').val() == $('#video-short-content-type-id').text() || $('#bx_block_contentmanagement_content_content_type_id option:selected').val() == $('#video-full-content-type-id').text();
};

const is_video_short = function(){
  return  $('#video-short-content-type-id').text() != "" && $('#bx_block_contentmanagement_content_content_type_id option:selected').val() == $('#video-short-content-type-id').text() && (($("#time_duration").val() == "0") || (parseFloat($("#time_duration").val()) > 30))
};

const is_video_full = function(){
  return $('#video-full-content-type-id').text() != "" && $('#bx_block_contentmanagement_content_content_type_id option:selected').val() == $('#video-full-content-type-id').text() && (($("#time_duration").val() == "0") || (parseFloat($("#time_duration").val()) < 30))
};

const video_size = function(){
  return parseFloat($("#video_size").val()) > 1000
};

const terms_and_condition_check = function(){
  return $('#bx_block_admin_admin_user_email').val() != "" && $('#bx_block_admin_admin_user_partner_attributes_name').val() != '' && $("#bx_block_admin_admin_user_partner_attributes_spoc_name").val() != "" && $("#bx_block_admin_admin_user_partner_attributes_spoc_contact").val() != ""
};

const change_url = function(){
  var email =  $('#bx_block_admin_admin_user_email').val();
  var name =  $('#bx_block_admin_admin_user_partner_attributes_name').val();
  var spoc_name =  $("#bx_block_admin_admin_user_partner_attributes_spoc_name").val();
  var spoc_contact =  $("#bx_block_admin_admin_user_partner_attributes_spoc_contact").val();
  var href = "/bx_block_roles_permissions/partners/terms_and_condition?email="+ email+ "&name="+ name+"&spoc_name="+spoc_name+"&spoc_contact=" + spoc_contact;
  $(".check_terms_and_condition").attr("href", href);
};

const update_feature_video_modal = function(){
  if(is_video()){
    $("#bx_block_contentmanagement_content_author_id");
    // $('#featue_video_area').show();
  } else{
    $("#bx_block_contentmanagement_content_author_id");
    $('#featue_video_area').hide();
  }
};

const update_author_modal = function(){
  if(is_blog()){
    $("#bx_block_contentmanagement_content_author_id").prop('required',true);
    $('#author_area').show();
  } else{
    $("#bx_block_contentmanagement_content_author_id").prop('required',false);
    $('#author_area').hide();
  }
};

$(function($) {
  update_author_modal();
  update_feature_video_modal();
  $(function($) {
    category_sub_category_dropdown();
    category_sub_category_dropdown_assessment();
    category_sub_category_dropdown_quiz();
    category_sub_category_dropdown_course();
    category_sub_category_dropdown_exam();
    category_sub_category_dropdown_for_muliple();
    review_status_dropdown();
    content_provider_dropdown();

    $(".content_save_btn").on("click", function(e){
      if(is_video_full()){
        $(".error-msg").html("Video can't be less than 30 seconds");
        e.preventDefault();
      }else if( is_video_short()){
        $(".error-msg").html("Video can't be more than 30 seconds");
        e.preventDefault();
      }

      if(video_size()){
        $(".error-msg").html("Video size can't be more than 1000 MB");
        e.preventDefault();
      }
    });

    $(".cls_terms_condition").on("change", function(){
      if(terms_and_condition_check()){
        $(".check_terms_and_condition").removeClass("terms_condition");
        $(".check_terms_and_condition").addClass("terms_condition_click");
        change_url();
      }else{
        $(".check_terms_and_condition").addClass("terms_condition");
        $(".check_terms_and_condition").removeClass("terms_condition_click");
      }
    });

    $('.request_sign_up_btn').on("click", function(e){
      e.preventDefault();
      if($("#terms_and_condition").is(':checked')){
        $("#new_post").submit();
      }else{
        $(".error-msg.red").html("Please check the terms and condition");
      }
    });



    $(document).on('click', '.check_terms_and_condition.terms_condition_click',function () {
      var email = $('#bx_block_admin_admin_user_email').val();
      var name =  $('#bx_block_admin_admin_user_partner_attributes_name').val();
      var spocName =  $("#bx_block_admin_admin_user_partner_attributes_spoc_name").val();
      var spocContact = $("#bx_block_admin_admin_user_partner_attributes_spoc_contact").val();
      
      $.ajax({
        type: "GET",
        url: "/bx_block_roles_permissions/partners/terms_and_condition",
        data: {email: email, name: name, spoc_name: spocName, spoc_contact: spocContact},
        success: function(result) {
        },
        error: function(e){
          console.log(e);
        }
      });
    });


    $('#bx_block_contentmanagement_content_content_type_id').on("change", function(){
      var text = $(this).text();
      var content_type_id = $(this).val();
      update_author_modal();
      update_feature_video_modal();
      if(content_type_id != "" && content_type_id != null){
        data = {text: text, id: content_type_id};
        call_content_detail_api(data);
      } else {
        $(".contentable_id").html('');
      }
    });

    $('.tag-select .chosen-select').chosen({
      no_results_text: 'No results matched, press Enter to create new tag: ',
      width: '100%'
    });

    $(".tag-select .chosen-container").on('keyup',function(event) {
      if(event.which === 13) {
        $(".tag-select .chosen-select").append('<option value="' + $(event.target).val() + '" selected="selected">' + $(event.target).val() + '</option>');
        $(".tag-select .chosen-select").trigger('chosen:updated');
      }
    });
  });

  content_form_setup();

  bannerable_type = $("#bx_block_contentmanagement_banner_bannerable_type :selected").val();
  if (bannerable_type != ''){
    selected = $("#bx_block_contentmanagement_banner_selected_bannerable_id").val();
    set_bannerable(selected);
  }

  $("#para_button").click(function () {
    create_author();
  });

  $("#bx_block_contentmanagement_banner_bannerable_type").on("change", function(){
    set_bannerable();
  });
});
