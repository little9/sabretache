var timerId = 0;
function Downloader() {
    this.title = '';
    this.description = '';
    this.collection = '';
}
Downloader.prototype = new Downloader();
Downloader.prototype.json = function () {
    // Function to return the object after the user has worked through the steps
    return JSON.stringify(this);
};
Downloader.prototype.download = function () {
    // A function to return dowload progress,
    // it checks the log file every five seconds
    $('.console-output').show();
    $('.next').hide();

    timerId = setInterval(function () {
        $.get('/downloadprogress', function (data) {
            console.log(data);
            $('.console-output').append(data);
        });
    }, 5000);
    $.post('/download', {"response": Downloader.prototype.json.call(this)}, function (response) {
        // Send the download information
        console.log(response);
        $('.console-output').show();
        $('.console-output').html(response);


    }).done(function (response) {
        // If the collection was downloaded, keep going...

        $('.download-results').show();
        $('.console-output').show();
        $('progress').hide();
        $('.previous').hide();
        $('.ok-notice').hide();
        $('.next').show();
        console.log("Done");
        clearInterval(timerId);
    }).fail(function () {
        $('.download-notice').html('');
        clearInterval(timerId);
        console.log("Failed");
    });

};
Downloader.prototype.fits = function () {
    // Create the fits metadata

    $.post('/fits', {"response": Downloader.prototype.json.call(this)}, function (response) {
        console.log(response);
        clearInterval(timerId);
        $('.console-output').html(response);
    }).done(function (response) {
        $('.fits-results').show();
        $('progress').hide();
        $('.previous').hide();
        $('.ok-notice').hide();
        $('.next').show();
    }).fail(function () {
        $('.fits-error').show();
    });
};
Downloader.prototype.bag = function () {
    // Create the bag
    $.post('/bag', {"response": Downloader.prototype.json.call(this)}, function (response) {
        $('.console-output').html(response);
    }).done(function (response) {
        $('.bag-results').show();
        $('progress').hide();
        $('.previous').hide();
    }).fail(function () {
        $('.bag-error').show();
    });
};
Downloader.prototype.tar = function () {
    // Tar the bag
    $.post('/tar', {"response": Downloader.prototype.json.call(this)}, function (response) {
        console.log(response);
        $('.console-output').html(response);
    }).done(function (response) {
        $('.tarring-results').show();
        $('progress').hide();
        $('.previous').hide();
        $('.ok-notice').hide();
        $('.next').show();
    }).fail(function () {
        $('.tar-error').show();
    });
};
Downloader.prototype.upload = function () {
    //Upload the bag
    $.post('/upload', {"response": Downloader.prototype.json.call(this)}, function (response) {
        $('.console-output').html(response);
    }).done(function (response) {
        $('.upload-results').show();
        $('progress').hide();
        $('.previous').hide();
        $('.ok-notice').hide();
    }).fail(function () {
        $('.upload-error').show();
    });
};

Downloader.prototype.files = function (path) {
    buildFileTree(path);
    checkBoxes();
};

Downloader.prototype.filesChecked = function () {
    var filelist = [];
    $('.filecheck').each(function (data) {
        if ($(this).prop('checked') != false) {
            filelist.push($(this).val());
        }
        console.log(filelist);
    });
    return filelist;
};
