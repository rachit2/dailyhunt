function close_video_modal(data){
  $(`#new_video_${data}`).html("");
}

$(function($) {
  var i = 0;
  var j = 0;
  // $('#video_div').append(`<div class="col-sm-7" id= "new_video_${j}"><label for="" class="col-sm-3 control-label">Video ${i}</label><input type="file" name="bx_block_contentmanagement_content[contentable_attributes][videos_attributes][${j}][video]"><label for="" class="col-sm-3 control-label">Thunbnail ${i}</label><input type="file" name="bx_block_contentmanagement_content[contentable_attributes][videos_attributes][${j}][image_attributes][image]"></div> <span class="img_close" id= "close_video_${j}" onclick="close_video_modal('#new_video_${j}', '#close_video_${j}')">&times;</span>`);
  
  $('#new_video').hide();
  $('#add_video').click(function() {
    i++;
    video_name = $('#video')[0];
    video_name.name = `bx_block_contentmanagement_content[contentable_attributes][videos_attributes][${i}][video]`;
    img_name = $('#image')[0];
    img_name.name = `bx_block_contentmanagement_content[contentable_attributes][videos_attributes][${i}][image_attributes][image]`;
    $('#video_div').append($('#new_video').html());
    $('#video_div div[id="new_video_0"]')[0].id = `new_video_close_video_${i}`;
    video_span = ($('#video_div span[id="close_video_0"]'));
    video_span.get(0).id = `close_video_${i}`;
  });


  $('#bx_block_contentmanagement_content_contentable_attributes_video_attributes_video').on('change', function(){
    var files = this.files;
    var video = document.createElement('video');
    var size = parseFloat((this.files[0].size / 1000000).toFixed(1))

    video.preload = 'metadata';
    $(".error-msg").html("");
    video.onloadedmetadata = function() {
      window.URL.revokeObjectURL(video.src);
      console.log(video.duration); // here it will print the video duration in secs
      $("#time_duration").val(video.duration);
    }
    video.src = URL.createObjectURL(files[0]);

    //this.files[0].size gets the size of your file.
    if(size > 1000){
      $(".error-msg").html("Video size can't be more than 1000 MB");
    }else{
      $(".error-msg").html("");
    }
    $("#video_size").val(size);
  });
});
