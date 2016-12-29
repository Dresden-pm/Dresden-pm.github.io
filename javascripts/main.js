window.addEvent('domready', function() {
    function md2site(file, id){new Request({url:file,onSuccess:function(r){insert2site(r, id)},onFailure:function(res){md2site('index.md', id)}}).send()};
    function insert2site(text, id){ $(id).set('html',new Showdown.converter().makeHtml(text))};
    md2site('header.md', 'header');
    md2site('footer.md', 'footer');
    var p = new URI(window.location.toString()).getData('page');
    md2site((p||'index')+'.md', 'content');
});
