const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const root = admin.database().ref();
const sgMail = require("@sendgrid/mail");
const ai2 = require("openai");
const configuration = new ai2.Configuration({
  apiKey: "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",
});
const openai = new ai2.OpenAIApi(configuration);
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

/*
exports.FavSong = functions.database.ref("/Users/{idIn}")
    .onWrite((change, context) => {
      // Grab the current value of what was written to the Realtime Database.
      let out = null;
      if (change.before.exists()) {
        if (change.before.child("FavoriteArtist/Name").val() != null) {
          const artistb = change.before.child("FavoriteArtist/Name").val();
          out = root.child("Artist").child(artistb).child(context.params.idIn)
              .remove();
        }
      }
      if (change.after.exists()) {
        if (change.after.child("FavoriteArtist/Name").val() != null) {
          functions.logger.log(change.after.child("ProfName").val());
          const name = change.after.child("ProfName").val();
          const scoreIn = change.after.child("FavoriteArtist/Score").val();
          const artist = change.after.child("FavoriteArtist/Name").val();
          out = root.child("Artist").child(artist)
              .child(context.params.idIn).set({Name: name, Score: scoreIn});
        }
      }
      return out;
    });
  */


exports.addName = functions.database.ref("/Users/{idIn}/ProfName")
    .onWrite((change, context) => {
      let out = null;
      let nameAfter = {};
      if (change.after.exists()) {
        nameAfter = change.after.val();
      }
      if (change.before.exists()) {
        const nameBefore = change.before.val();
        out = root.child("/Usernames").child(String(nameBefore))
            .set({});
        out = root.child("/PrivateUsers").child(nameBefore).set({});
        root.child("/PrivateUsers").once("value").then(function(snapshot) {
          if (snapshot.child(nameBefore).val()) {
            out = root.child("/PrivateUsers").child(nameAfter).set(nameAfter);
          }
        });
      }
      out = root.child("/Usernames").child(String(nameAfter))
          .set(context.params.idIn);
      return out;
    });

exports.favTrack = functions.database.ref("/Users/{idIn}/TracksJson")
    .onWrite((change, context) => {
      // Grab the current value of what was written to the Realtime Database.
      let out = null;
      if (change.after.exists()) {
        const b = change.after.val();
        const obj = JSON.parse(b);
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteTrackData").set(obj);
      }
      return out;
    });

exports.tempName = functions.database.ref("/Users/{idIn}")
    .onWrite((change, context) => {
      let out = null;
      if (change.after.val() == null) {
        return;
      }
      if (! change.after.hasChild("ProfName")) {
        out = root.child("/Users").child(String(context.params.idIn))
            .child("ProfName").set(String(context.params.idIn));
      }
      if (! change.after.hasChild("Bio")) {
        out = root.child("/Users").child(String(context.params.idIn))
            .child("Bio").set(" ");
      }
      if (! change.after.hasChild("IsPrivate")) {
        out = root.child("/Users").child(String(context.params.idIn))
            .child("IsPrivate").set("False");
      } else if (change.after.child("IsPrivate").val() == "False" &&
      (change.before.child("IsPrivate").exists() &&
      change.before.child("IsPrivate").val() == "True") ) {
        const name = change.before.child("ProfName").val();
        out = root.child("/PrivateUsers").child(name).set({});
      } else if (change.after.child("IsPrivate").val() == "True") {
        const name = change.after.child("ProfName").val();
        out = root.child("/PrivateUsers").child(name).set(
            String(context.params.idIn));
      }
      if (change.after.child("IsPrivate").val() == "True") {
        out = root.child("/ExploreList").child(
            String(context.params.idIn)).set({});
      }
      if (! change.after.hasChild("ProfPic")) {
        out = root.child("/Users").child(String(context.params.idIn))
            .child("ProfPic").set("NULL");
      }
      if (! change.after.hasChild("WIP")) {
        out = root.child("/Users").child(String(context.params.idIn))
            .child("WIP").set({"FavoriteGenre": "True",
              "FunFacts": "True", "TopAlbums": "True",
              "TopArtists": "True", "TopTracks": "True",
              "TopTracksShort": "True", "TopTracksLong": "True",
              "TopArtistsShort": "True", "TopArtistsLong": "True"});
      }
      if (! change.after.hasChild("email")) {
        out = root.child("/Users").child(String(context.params.idIn))
            .child("email").set("NULL");
      }
      if (! change.after.hasChild("Friends")) {
        out = root.child("/Users").child(String(context.params.idIn))
            .child("Friends").set({"NULL": "NULL"});
      }
      return out;
    });

exports.Emailing = functions.database.ref("/Users/{idIn}/email")
    .onWrite((change, context) => {
      const apikey =
        "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";
      sgMail.setApiKey(apikey);
      const msg = {
        to: change.after.val(), // Change to your recipient
        from: "SprofilApp@gmail.com", // Change to your verified sender
        subject: "Welcome to MySpot :D",
        text: `Welcome to MySpot We hope you like the application and share 
        it with friends! Team Ben, Tejas, Kevin`,
        html: `<p><span style="text-decoration: underline;">Welcome to 
        <strong>MySpot</strong>!</span></p>
        <p>&nbsp;</p>
        <p>We hope you like the application and share it with friends!</p>
        <p>&nbsp;</p>
        <p>Team</p>
        <p>Ben, Tejas, Kevin</p>`,
      };
      sgMail
          .send(msg)
          .then(() => {
            console.log("Email sent");
          })
          .catch((error) => {
            console.error(error);
          });
    });


exports.favArtistshort = functions.database
    .ref("/Users/{idIn}/artistJSON_short").onWrite((change, context) => {
      let out = null;
      if (change.after.exists()) {
        const jsonart = change.after.val();
        const obj = JSON.parse(jsonart);
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteArtistData_short").set(obj);
        const favGenreScore = {};
        const marioKart = [15, 12, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
        for (let i = 0; i < obj.items.length; i ++) {
          const curr = obj.items[i];
          for (let j = 0; j < curr.genres.length && j < 12; j ++) {
            const currgenre = curr.genres[j];
            if (currgenre in favGenreScore) {
              favGenreScore[currgenre] += marioKart[j];
            } else {
              favGenreScore[currgenre] = marioKart[j];
            }
          }
        }
        const scores = favGenreScore;
        // Step - 1
        // Create the array of key-value pairs
        const items = Object.keys(scores).map(
            (key) => {
              return [key, scores[key]];
            });

        // Step - 2
        // Sort the array based on the second element (i.e. the value)
        items.sort(
            (first, second) => {
              return first[1] - second[1];
            }
        );

        // Step - 3
        // Obtain the list of keys in sorted order of the values.
        let keys = items.map(
            (e) => {
              return e[0];
            });
        keys = keys.reverse();
        const best = [];
        const titles = ["nerd", "fanatic",
          "king/queen", "scholar", "missionary", "worshipper"];

        for (let i = 0; i < keys.length && i < 3; i ++) {
          const genre = keys[i];

          best.push({genre: keys[i], score: scores[genre]});
        }
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteGenre").set(best);
        const random = Math.floor((Math.random() * 6));
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteGenre").child("Title").set(titles[random]);
      }
      return out;
    });


exports.favArtistmedium = functions.database
    .ref("/Users/{idIn}/artistJSON_medium").onWrite((change, context) => {
      let out = null;
      if (change.after.exists()) {
        const jsonart = change.after.val();
        const obj = JSON.parse(jsonart);
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteArtistData").set(obj);
      }
      return out;
    });

exports.favArtistLong = functions.database.ref("/Users/{idIn}/artistJSON_long")
    .onWrite((change, context) => {
      let out = null;
      if (change.after.exists()) {
        const jsonart = change.after.val();
        const obj = JSON.parse(jsonart);
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteArtistData_long").set(obj);
      }
      return out;
    });

exports.favArtistLong = functions.database.ref("/Users/{idIn}/artistJSON_long")
    .onWrite((change, context) => {
      let out = null;
      if (change.after.exists()) {
        const jsonart = change.after.val();
        const obj = JSON.parse(jsonart);
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteArtistData_long").set(obj);
      }
      return out;
    });

exports.friends = functions.database.ref("/Users/{idIn}/Friends/{friendId}")
    .onWrite((change, context) => {
      let out = null;
      if (context.params.friendId == "NULL") {
        return out;
      }
      if (change.after.exists()) {
        // const friendval = change.after.val();
        out = root.child("/Users").child(String(context.params.friendId))
            .child("Friends").child(context.params.idIn)
            .set(context.params.idIn);
      } else {
        out = root.child("/Users").child(String(context.params.friendId))
            .child("Friends").child(context.params.idIn).set({});
      }
      return out;
    });

exports.favTrackLong = functions.database.ref("/Users/{idIn}/trackJSON_long")
    .onWrite((change, context) => {
      // Grab the current value of what was written to the Realtime Database.
      let out = null;
      if (change.after.exists()) {
        const b = change.after.val();
        const obj = JSON.parse(b);
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteTrackData_long").set(obj);
      }
      return out;
    });

exports.favTrackMedium = functions.database
    .ref("/Users/{idIn}/trackJSON_medium").onWrite((change, context) => {
      // Grab the current value of what was written to the Realtime Database.
      let out = null;
      if (change.after.exists()) {
        const b = change.after.val();
        const obj = JSON.parse(b);
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteTrackData").set(obj);
      }
      return out;
    });

exports.favTrackShort = functions.database.ref("/Users/{idIn}/trackJSON_short")
    .onWrite((change, context) => {
      // Grab the current value of what was written to the Realtime Database.
      let out = null;
      if (change.after.exists()) {
        const b = change.after.val();
        const obj = JSON.parse(b);
        out = root.child("/Users").child(String(context.params.idIn))
            .child("FavoriteTrackData_short").set(obj);
      }
      return out;
    });

exports.consoleLogPrinter2 = functions.pubsub.schedule("15 0 * * *")
    .timeZone("America/New_York")
    .onRun((context) => {
      let out = null;
      root.once("value").then(function(snapshot) {
        const author = snapshot.val();
        const user = author.Users;
        const explore = {};
        let i = 0;
        while (Object.keys(explore).length < 10 && i < 50) {
          i = i + 1;
          const userKeys = Object.keys(user);
          const count = userKeys.length;
          const random = Math.floor((Math.random() * count));
          const randomUser = Object.keys(user)[random];
          const randomInt = Math.floor((Math.random() * 20));
          const path = "/Users/" + randomUser +
          "/FavoriteArtistData/items/" + randomInt + "/images/0/url";
          const path2 = "/Users/" + randomUser + "/IsPrivate";
          const privateVal = snapshot.child(path2).val();
          const childVal = snapshot.child(path).val();
          if (childVal && privateVal == "False") {
            explore[randomUser] = childVal;
          }
        }
        out = root.child("ExploreList").set(explore);
      });
      return out;
    });

exports.getColor = functions.database.
    ref("/Users/{idIn}/FavoriteGenre/{idIn2}/genre")
    .onWrite((change, context) => {
      let out = null;
      const genreIn = change.after.val();
      const prompt = `Give me a Hex Color for the Music Genre
    Genre: Christan Rock
    Color: #4E2683
    Genre: Jazz
    Color: #fcba03
    Genre: ${genreIn}
    Color: #`;
      const blah2 = openai.createCompletion("text-davinci-002", {
        prompt: prompt,
        temperature: 0.6,
      });

      blah2.then(function(data) {
        out = change.after.ref.parent
            .child("Color").set(data.data.choices[0].text);
      });
      return out;
    });

exports.noPic = functions.database
    .ref("/Users/{idIn}/FavoriteArtistData/items/0/images/0/url")
    .onWrite((change, context) => {
      let out = null;
      if (change.after.val()) {
        out = root.child("/Users").child(String(context.params.idIn))
            .child("ProfPic").set(change.after.val());
      }
      return out;
    });
