// Compat SDKs ko import karein (Web Service Worker ke liye yehi standard hai)
importScripts("https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js");

// Firebase initialize karein
firebase.initializeApp({
  apiKey: "AIzaSyBcPkD24z5Pd1hA3idX4ZnOw2zE4mcxrP4",
  authDomain: "nexus-texh-group-ltd.firebaseapp.com",
  projectId: "nexus-texh-group-ltd",
  storageBucket: "nexus-texh-group-ltd.firebasestorage.app",
  messagingSenderId: "532500206034",
  appId: "1:532500206034:web:0c31feb5dbab22da97f80b",
});

const messaging = firebase.messaging();

// Background messages handle karne ke liye
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  // Payload check karein taake agar notification data khali ho to crash na ho
  const notificationTitle = payload.notification ? payload.notification.title : "New Notification";
  const notificationOptions = {
    body: payload.notification ? payload.notification.body : "",
    icon: '/icons/Icon-192.png' // App icon path
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});