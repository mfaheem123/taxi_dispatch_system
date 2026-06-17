importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

// Firebase initialize karein (Apni settings yahan dalein)
firebase.initializeApp({
  apiKey: "AIzaSyDDxZ8lPfTJ1XcUn_7HpyvExygoWxgQR-A",
  authDomain: "texidispetchsystem.firebaseapp.com",
  projectId: "texidispetchsystem",
  storageBucket: "texidispetchsystem.firebasestorage.app",
  messagingSenderId: "81697669010",
  appId:"1:81697669010:web:388758b1deabeb4af60b4b",
});

const messaging = firebase.messaging();

// Background messages handle karne ke liye
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png' // Aapka app icon path
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});