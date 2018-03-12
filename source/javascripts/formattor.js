//= require ./lib/_jquery

$(function () {
    var tag_to_wrap_simple = 'p,ul,aside,table,h4,h5,h6';
    var tag_to_wrap_breaking = 'h3';
    var tag_to_wrap = tag_to_wrap_simple + ',' + tag_to_wrap_breaking;
    $('.page-wrapper .content').children()
    .filter(function() {
        return  $(this).is(tag_to_wrap_breaking) ||
               ($(this).is(tag_to_wrap_simple) && !$(this).prev().is(tag_to_wrap));
    })
    .map(function() {
        return $(this).nextUntil(":not(" + tag_to_wrap_simple + ")").andSelf();
    })
    .wrap('<div class="content-wrapper" />');


    /*
    var tag_to_wrap = 'p,ul,aside,table';
    $('.page-wrapper .content').children()
    .filter(function() {
        return $(this).is(tag_to_wrap) && !$(this).prev().is(tag_to_wrap);
    })
    .map(function() {
        return $(this).nextUntil(":not(" + tag_to_wrap + ")").andSelf();
    })
    .wrap('<div class="content-wrapper" />');
    */
});
