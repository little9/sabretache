/**
 * Created by jamie on 2/28/16.
 */
String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};
function makeTree(files,parent) {
    var element;
    if (files.text) {
        if (parent !== null) {
            element = '#' + files.text.replaceAll('/','_');
            $('#' + parent).append("<input class='file-selection dircheck' type='checkbox' value='"+ files.text +"'><i class='fa fa-folder'></i><li id='"+ files.text.replaceAll('/','_') +"'>" + files.text + "</li>")
        } else {
            element = '#' + files.text.replaceAll('/','_');
            $('#filetree').append("<input class='file-selection dircheck' type='checkbox' value='"+ files.text +"'><i class='fa fa-folder'></i><li id='"+ files.text.replaceAll('/','_') +"'>" + files.text + "</li>")
        }
    }
    for (var i=0; i<files.children.length; i++) {
        if (typeof files.children[i] === 'object') {
            makeTree(files.children[i], files.text.replaceAll('/','_'));
        }  else {

            $(element).append("<li><input class='file-selection filecheck' type='checkbox' value='"+ files.text + '/' + files.children[i] +"'><i class='fa fa-file'></i>"+ files.children[i] +"</li>");
        }
    }
};


