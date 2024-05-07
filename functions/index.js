const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

admin.initializeApp({
   serviceAccountId: 'firebase-adminsdk-snja0@multi-auth-af8c7.iam.gserviceaccount.com',
});

exports.generateCustomToken = functions.https.onCall((data, context) => {
    return admin.auth()
                .createCustomToken(data.uid)
                .then(customToken => {
                    console.log(`The customToken is: ${customToken}`);
                    return {status: 'success', customToken: customToken};
                })
                .catch(error => {
                    console.error(`Something happened buddy: ${error}`)
                    return {status: `Something happened error: ${error}`};
                });
});
