const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onFollowUser = functions.firestore
.document('/followers/{userId}/userFollowers/{followerId}')
.onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const followerId = context.params.followerId;
    const followedUserPostsRef = admin
    .firestore()
    .collection('posts')
    .doc(userId)
    .collection('usersPosts');
    const userFeedRef = admin.firestore()
    .collection('feeds')
    .doc(followerId)
    .collection('userFeed');

    const followedUserPostsSnapShot = await followedUserPostsRef.get();
    followedUserPostsSnapShot.forEach( doc => {
        if (doc.exists){
            userFeedRef.doc(doc.id).set(doc.data());
        }
    });
});

exports.onUnFollowUser = functions.firestore
.document('/followers/{userId}/userFollowers/{followerId}')
.onDelete(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const followerId = context.params.followerId;
    const userFeedRef = admin
    .firestore()
    .collection('feeds')
    .doc(followerId)
    .collection('userFeed')
    .where('authorId', '==', userId);
    const userPostsSnapShot = await userFeedRef.get();
    userPostsSnapShot.forEach( doc => {
        if (doc.exists) {
            doc.ref.delete();
        }
    });
});

exports.onUploadPost = functions.firestore
.document('/posts/{userId}/usersPosts/{postId}')
.onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const postId = context.params.postId;
    const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
    const userFollowersSnapsShot = await userFollowersRef.get();
    userFollowersSnapsShot.forEach(doc => {
        admin
        .firestore()
        .collection('feeds')
        .doc(doc.id)
        .collection('userFeed')
        .doc(postId)
        .set(snapshot.data());
    });
});

exports.onUpdatePost = functions.firestore
.document('/posts/{userId}/usersPosts/{postId}')
.onUpdate(async (snapshot, context) => {
    const userId = context.params.userId;
    const postId = context.params.postId;
    const newPostData = snapshot.after.data();
    console.log(newPostData);
    const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
    const userFollowersSnapsShot = await userFollowersRef.get();
    userFollowersSnapsShot.forEach(async userDoc => {
        const postRef = admin
        .firestore()
        .collection('feeds')
        .doc(userDOc.id)
        .collection('userFeed');
        const postDoc = await postRef.doc(postId).get();
        if (postDoc.exists) {
            postDoc.ref.update(newPostData);
        }
    });
});
