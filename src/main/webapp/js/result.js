$(function () {
    fetch('/json/result.json')
        .then(res => res.json())
        .then(data => {
            console.log(data);
        });


})