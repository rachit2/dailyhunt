function close_file_modal(data){
  $(`#new_file_${data}`).html("");
}

$(function($) {

  const change_file_code = function(){
    $(".pdf_select_button").on("click",function () {
      $(this).siblings("input[type='file']").trigger('click');
    });

    $("input[type='file'].pdf_select_file").change(function () {
      $(this).siblings("span#val").text(this.value.replace(/C:\\fakepath\\/i, ''))
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

  // var i = 0;
  // $('#add_file').click(function() {
  //   i++;
  //   $('#file_div').append(`<div class="col-sm-7" id= "new_file_${i}"><input type="file" name="bx_block_contentmanagement_content[contentable_attributes][pdfs_attributes][${i}][pdf]"></div> <span class="img_close" id= "close_file_${i}" onclick="close_file_modal('#new_file_${i}', '#close_file_${i}')">&times;</span>`);
  // });
  var i = parseInt($('#pdf_index').val()) || 0;
  
  $('#new_file').hide();
  $('#add_file').click(function() {
    
    $(".epub_file_err_msg").html("");
    var show_choose_file = true;
    
    $("#file_div #file").each(function(){
      if($(this)[0].files.length === 0){
        show_choose_file = false;
      }
    });

    if(show_choose_file){
      i++;
      file_name = $('#file')[0];
      file_name.name = `bx_block_contentmanagement_content[contentable_attributes][pdfs_attributes][${i}][pdf]`;
      $('#file_div').append($('#new_file').html());
      $('#file_div div[id="new_file_0"]')[0].id = `new_file_close_file_${i}`;
      image_span = ($('#file_div span[id="close_file_0"]'));
      image_span.get(0).id = `close_file_${i}`
      change_file_code();
    }else{
      $(".epub_file_err_msg").html("Please choose the previous file to upload.");
    }
  });
  change_file_code();
});
