const functions = require("firebase-functions");
const admin = require('firebase-admin');
const { user } = require("firebase-functions/v1/auth");

admin.initializeApp(functions.config().firebase);

exports.createDriver = functions.https.onCall(async (data,context)=>{
    const routeNumber = data.routeNo;
    const emailId = data.email;
    functions.logger.log(emailId);
    admin.auth().getUserByEmail(`${emailId}`).then(userRecord => {
        admin.auth().setCustomUserClaims(userRecord.uid, {userType: "driver", routeNo:routeNumber});
    })
    // admin.auth().setCustomUserClaims(uid, {userType: "driver", routeNo:routeNumber});
});

exports.createPassenger = functions.https.onCall(async (data,context)=>{
    admin.auth().setCustomUserClaims(userRecord.uid, {userType: "traveller"});
});
