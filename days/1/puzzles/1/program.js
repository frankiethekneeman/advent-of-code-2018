let input = ""

process.stdin.on('data', function(chunk) {
    input += chunk;
});
process.stdin.on('end', function() {
    doItMessy = '0' + input.replace(/[^0-9-+]/g, '');
    console.log(eval(doItMessy))
});
