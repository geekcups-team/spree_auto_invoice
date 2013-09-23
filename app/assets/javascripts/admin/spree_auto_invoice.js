//= require admin/spree_backend
$(function(){
  $('#download_zip').on('click',function(){
     $('#download_zip').attr('href',$('#download_zip').attr('href') + '?' + $('<textarea/>').html($('#spree\\/order_search').serialize()).text());
  })
})