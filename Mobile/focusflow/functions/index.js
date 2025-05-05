/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// functions/src/index.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as sgMail from "@sendgrid/mail";

admin.initializeApp();
const db = admin.firestore();
sgMail.setApiKey(functions.config().sendgrid.key);

export const notifyAssignedMembers = functions.firestore
  .document("workspaces/{workspaceId}/boards/{boardId}/tasks/{taskId}")
  .onCreate(async (snap, context) => {
    const task = snap.data();
    const assignedTo = task.assignedTo || [];
    const taskTitle = task.title;

    for (const userId of assignedTo) {
      const userDoc = await db.collection("users").doc(userId).get();
      if (userDoc.exists) {
        const email = userDoc.data()?.email;
        if (email) {
          const msg = {
            to: email,
            from: "your_verified_sender@example.com", // Must be a verified sender in SendGrid
            subject: `You've been assigned a new task`,
            text: `You've been assigned to task "${taskTitle}". Please check your dashboard.`,
          };
          await sgMail.send(msg);
        }
      }
    }
  });
