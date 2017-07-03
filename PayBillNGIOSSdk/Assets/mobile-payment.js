function makePayment(data){
    var config = JSON.parse(data);

    config.onClose=function(ref){
        try {
            webkit.messageHandlers.callbackHandler.postMessage("close");
        } catch(err) {
            console.log('The native context does not exist yet');
        }
    }

    PayBillService.load(config);
}

try {
    webkit.messageHandlers.callbackHandler.postMessage("loaded");
} catch(err) {
    console.log('The native context does not exist yet');
}
