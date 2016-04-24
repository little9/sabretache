function buildFileTree(filepath) {
    $.getJSON(window.location.href + 'files' + filepath, function (response) {
        makeTree(response.data, null);
    });
}
function checkBoxes() {
    // Handle checkbox behaviour
    $('#filetree').on("change", ".dircheck", function () {
        var checkstatus = $(this).prop("checked");
        var dir = $(this).val();

        $('.filecheck').each(function (index) {
            if ($(this).val().localeCompare(dir) > -1) {
                $(this).prop("checked", checkstatus);
            }
        });
    });
    $('#filetree').on("change", ".filecheck", function () {
        console.log($(this).next());
    });
    $('.select-all').on('click', function () {
        if ($('.filecheck').prop('checked') == false) {
            $('.filecheck').prop('checked', true);
        } else {
            $('.filecheck').prop('checked', false);
        }
    });
}


function getFreeSpace() {
    // Get the amount of free space on the /media/APTrust drive
    var freespace;
    var freespaceNumber;
    $.get('/freespace', function (response) {
    }).done(function (response) {
        freespace = JSON.parse(response);
        freespaceNumber = freespace.free_space
        $('.storage-notice').html("You've got " + freespaceNumber + " gigabytes of free storage.").append("<p>You probably shouldn't download a collection bigger than " + freespaceNumber / 4 + " gigabytes.</p>");
    }).fail(function (response) {
    });
    return freespace;
}
$(document).ready(function () {
    getFreeSpace();
    var downloader = new Downloader();
    $('section').hide();
    $('section').first().show();
    $('.next').show();
    $('.next').on('click', function () {
        $('.previous').show();
        $(this).parent().hide();
        $(this).parents().next().show();
        $('.download-notice').hide();
        $('progress').hide();
        $('.console-output').hide();
        downloader.fileTypes = $('.file-types-selection').val();
        downloader.title = $('input.title').val();
        downloader.description = $('input.description').val();
        downloader.files = downloader.filesChecked();
    });

    $('.previous').on('click', function () {
        $(this).parent().hide();
        $(this).parents().prev().show();
    });

    $('.explore-dir').on('click', function () {
        $('.controls').show();
        var repocoll = $(this).data().remoteRoot;
        buildFileTree(repocoll);
        checkBoxes();
        $('.explore-dir').hide();
    });

    $('.submit').on('click', function () {
        $(this).hide();
        $('progress').show();
        $('.next').hide();
        $('.previous').hide();
        $('.download-notice').show();
        downloader.download();
    });

    $('.run-fits').on('click', function () {
        $(this).hide();
        $('progress').show();
        $('.next').hide();
        $('.previous').hide();
        downloader.fits();
    });

    $('.bag').on('click', function () {
        $(this).hide();
        $('.progress').show();
        $('.next').show();
        downloader.bag();
    });

    $('.tar').on('click', function () {
        $(this).hide();
        $('.progress').show();
        $('.next').show();
        downloader.tar();
    });

    $('.upload').on('click', function () {
        $(this).hide();
        $('.progress').show();
        $('.next').show();
        downloader.upload();
    });
});