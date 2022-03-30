function close_image_modal(data){
  $(`#new_image_${data}`).html("");
}

function close_video_modal(data){
  console.log(data);
  $(`#new_video_${data}`).html("");
}

$(function($) {

  const change_file_code = function(){
    $(".pdf_select_button").on("click",function () {
      $(this).siblings("input[type='file']").trigger('click');
    });

    $("input[type='file'].pdf_select_file").change(function () {
      $(this).siblings("span#val").text(this.value.replace(/C:\\fakepath\\/i, ''))
      if ($(this).attr("id") == "video"){
        var size = parseFloat((this.files[0].size / 1000000).toFixed(1))

        if(size > 1000){
          $(".text_video_err_msg").html("Video size can't be more than 1000 MB");

        }else{
          $(".text_video_err_msg").html("");
        }
        $("#video_size").val(size);
      }  
    });
  }

  $(".destroy_btn").on("click", function(){
    if($(this).hasClass("btn-danger")){
      $(this).siblings(".destroy_val").val("false");
      $(this).addClass("btn-default");
      $(this).removeClass("text-white");
      $(this).removeClass("btn-danger");
    }else{
      $(this).siblings(".destroy_val").val("true");
      $(this).addClass("btn-danger");
      $(this).addClass("text-white");
      $(this).removeClass("btn-default");
    }
  });

  var i = parseInt($('#image_index').val()) || 0;
  var j = parseInt($('#video_index').val()) || 0;
  $('#new_image').hide();
  $('#new_video').hide();
  $('#add_image').click(function() {

    $(".text_image_err_msg").html("");
    var show_choose_file = true;
    $("#img_div #image").each(function(){
      if($(this)[0].files.length === 0){
        show_choose_file = false;
      }
    });

    if(show_choose_file){
      i++;
      img_name = $('#image')[0];
      img_name.name = `bx_block_contentmanagement_content[contentable_attributes][images_attributes][${i}][image]`;
      $('#img_div').append($('#new_image').html());
      $('#img_div div[id="new_image_0"]')[0].id = `new_image_close_image_${i}`;
      image_span = ($('#img_div span[id="close_image_0"]'));
      image_span.get(0).id = `close_image_${i}`
      change_file_code();
    }
    else{
      $(".text_image_err_msg").html("Please choose the previous image to upload.");
    }
  });

  $('#add_video').click(function() {

    $(".text_video_err_msg").html("");

    var check_video_size = parseFloat($("#video_size").val()) || 0;
    var show_choose_file = true;
    $("#video_div #video").each(function(){
      if($(this)[0].files.length === 0){
        show_choose_file = false;
      }
    });

    if(show_choose_file && (check_video_size  == 0 || check_video_size < 1000) ){
      j++;
      // $('#video_div').append(`<div class="col-sm-7" id= "new_video_${j}"><input type="file" name="bx_block_contentmanagement_content[contentable_attributes][videos_attributes][${j}][video]"></div> <span class="img_close" id= "close_video_${j}" onclick="close_video_modal('#new_video_${j}', '#close_video_${j}')">&times;</span>`);

      video_name = $('#video')[0];
      video_name.name = `bx_block_contentmanagement_content[contentable_attributes][videos_attributes][${j}][video]`;
      $('#video_div').append($('#new_video').html());
      $('#video_div div[id="new_video_0"]')[0].id = `new_video_close_video_${j}`;
      video_span = ($('#video_div span[id="close_video_0"]'));
      video_span.get(0).id = `close_video_${j}`
      change_file_code();
    }else{
      if (check_video_size > 1000){
        $(".text_video_err_msg").html("Video size can't be more than 1000 MB");
      }
      else{
        $(".text_video_err_msg").html("Please choose the previous video to upload.");
      }
    }
  });
  change_file_code();
});
